FROM smebberson/alpine-nodejs:5.2.1

ENV NODE_ENV="development"

ADD root/app/package.json /app/

RUN cd /app && \
    npm install --production

# Copy across the source for the app
ADD root /
