# Base image
FROM python:3.10-slim

# Atualiza e instala libs necessárias
RUN apt-get update && apt-get install -y \
  libjpeg-dev zlib1g-dev libpng-dev libfreetype6-dev libpq-dev build-essential \
  && rm -rf /var/lib/apt/lists/*

# Diretório de trabalho
WORKDIR /usr/src/app

# Copia e instala dependências
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copia o código
COPY . .

# Exporta arquivos estáticos
RUN python manage.py collectstatic --noinput

# Variáveis de ambiente definidas em tempo de execução via Fly secrets
ENV DATABASE_URL=""
ENV SECRET_KEY=""
ENV DEBUG="False"
ENV ALLOWED_HOSTS=""
ENV CORS_ALLOWED_ORIGINS=""

# Porta para Gunicorn
EXPOSE 8000

# Comando para rodar Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "3", "bye_money.wsgi:application"]
