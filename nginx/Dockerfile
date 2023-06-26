# Use official nginx image as the base
FROM nginx

# Remove default configuration
RUN rm /etc/nginx/conf.d/default.conf

# Copy locally created nginx configuration
COPY default.conf /etc/nginx/conf.d/default.conf