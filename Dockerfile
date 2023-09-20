FROM  python:3.11.3-alpine3.18
LABEL mantainer="mathpcv@gmail.com"

# Essa variável de ambiente é usada para controlar se o Pyhton deve gravar arquivos de bytecode (.pyc) no disco. 1 = Não, 0 = Sim
ENV PYTHONDONTWRITEBYTECODE 1

# Define que a saída do Pyhton será exibida imediatamente no console ou em outros dispositivos de saída, sem ser armazenada em  buffer. Em resumo, você verá os outputs do Python em tempo real. 
ENV PYTHONUNBUFFERED 1

# Copia a pasta "djangoapp" e "scripts" para dentro do container
COPY djangoapp /djangoapp
COPY djangoapp djangoapp

# Entra na pasta djangoapp no container para facilitar o run para o Django.
WORKDIR /djangoapp

# A porta 8000 estará disponível para conexões externas ao container. É a porta que vamos usar para o Django.
EXPOSE 8000

# RUN executa comandos em um shell dentro do container para construir uma imagem. O resultado da execução do comando é armazenado no sistema de arquivos da imangem como uma nova camada. Agrupar os comando em um único RUN pode reduzir a quantidade de camadas da imagem e torná-la mais eficientes.
RUN python -m venv /venvv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install -r /djangoapp/requirements.txt && \
    adduser --disable-password --no-create-home duser && \
    mkdir -p /data/web/static && \
    mkdir -p /data/web/media && \
    chown -R duser:duser /venv && \
    chown -R duser:duser /data/web/static && \
    chown -R duser:duser /data/web/media && \
    chmod -R 755 /data/web/static && \
    chmod -R 755 /data/web/media && \
    chmod -R +x /scripts

# Adiciona a pasta scripts e venv/bin. no $PATH do container.
ENV PATH="/scripts:/venv/bin:$PATH"

# Muda o usuário para duser
USER duser

# Executa o arquivo scripts/commands.sh
CMD ["commands.sh"]
