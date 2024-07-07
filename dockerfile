#build stage
FROM node:21.7.2-slim as build

WORKDIR /usr/src/app

COPY package*.json ./

ENV GENERATE_SOURCEMAP=false
ENV NODE_OPTIONS=--max-old-space-size=2048

RUN npm install --f

COPY . .

RUN npm run build

#prod stage
FROM node:21.7.2-slim

WORKDIR /usr/src/app

ARG prod=production
ENV NODE_ENV=${prod}
ENV PORT=4000
ENV DEFAULT_CURRENCY=USD

COPY --from=build /usr/src/app/dist ./dist

COPY package*.json ./

RUN npm install --only=production --f

RUN rm package*.json

EXPOSE 4000

CMD ["node", "dist/main.js"]