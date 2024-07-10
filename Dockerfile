# Stage 1: Construir a aplicação
FROM node:18 AS build

# Define o diretório de trabalho no contêiner
WORKDIR /app

# Copia o package.json e o yarn.lock para o diretório de trabalho
COPY package.json yarn.lock ./

# Instala as dependências usando Yarn
RUN yarn install --frozen-lockfile

# Copia o restante do código da aplicação para o diretório de trabalho
COPY . .

# Constrói a aplicação Next.js para produção
RUN yarn build

# Stage 2: Rodar a aplicação em produção
FROM node:18-alpine

# Define o diretório de trabalho no contêiner
WORKDIR /app

# Copia os arquivos necessários da primeira fase
COPY --from=build /app/package.json /app/yarn.lock ./
COPY --from=build /app/.next ./.next
COPY --from=build /app/public ./public

# Instala dependências apenas para produção
RUN yarn install --frozen-lockfile --production

# # Define a variável de ambiente NODE_ENV para produção
# ENV NODE_ENV=production

# Expõe a porta que a aplicação vai rodar
EXPOSE 3000

# Comando para iniciar a aplicação
CMD ["yarn", "start"]