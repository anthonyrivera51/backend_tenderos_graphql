#build stage
FROM node:18-alpine as build

WORKDIR /usr/src/app

COPY package*.json ./

ENV GENERATE_SOURCEMAP=false
ENV NODE_OPTIONS=--max-old-space-size=16384

RUN npm install --f

COPY . .

RUN yarn build

#prod stage
FROM node:18-alpine

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