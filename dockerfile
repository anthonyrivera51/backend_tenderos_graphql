FROM node:18-alphine as build

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm install --global yarn

RUN npm run build

#prod stage
FROM node:18-alphine

WORKDIR /usr/src/app

ARG prod=production
ENV NODE_ENV=${prod}
ENV PORT=4000
ENV DEFAULT_CURRENCY=USD

COPY --from=build /usr/src/app/dist ./dist

COPY package*.json ./

RUN npm install --only=production

RUN rm package*.json

EXPOSE 4000

CMD ["node", "dist/main.js"]