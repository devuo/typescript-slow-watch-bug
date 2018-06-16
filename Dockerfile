FROM node:8-alpine

EXPOSE 4488 5082

WORKDIR /app

CMD ["node", "dist/index.js"]
