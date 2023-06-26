# Use official Node.js image as the base
FROM node:16-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json files
COPY ["package.json", "package-lock.json", "./"]

# Install the dependencies
RUN npm install

# Copy the source code to the container
COPY . .

# Build the React app
RUN npm run build

# Use port 3000 for communication
EXPOSE 3000

# Set the command to start the application
CMD ["npm", "start"]