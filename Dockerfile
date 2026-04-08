# Use a lightweight Nginx image
FROM nginx:stable-alpine

# Copy the contents of your local dist folder into the container's web root
COPY dist/ /usr/share/nginx/html

# Expose port 80 for web traffic
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
