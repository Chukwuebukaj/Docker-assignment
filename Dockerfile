# Use an official Node.js runtime as a parent image
FROM node:18 AS layer

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Install any needed packages specified in package.json
RUN yarn

RUN yarn tsc

FROM node:18-alpine AS app

WORKDIR /app

COPY --from=layer /app/dist ./dist

COPY package.json .

COPY yarn.lock .

RUN yarn --production

COPY bin ./bin

COPY --from=layer /app/client/build ./client/build

COPY --from=layer /app/client/public ./client/public

COPY client/package.json .

COPY client/yarn.lock .

# Run app.js when the container launches
CMD ["node", "bin/www"]

# Make port 3000 available to the world outside this container
EXPOSE 3000

