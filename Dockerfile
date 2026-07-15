FROM nginx:alpine
COPY . /usr/share/nginx/html/
# I used . instead of COPY because I wanted everythinf that is not in the .dockerignore to be 
# copied to the container. 
# I also used nginx:alpine because it is a lightweight image that is easy to use and has a small footprint.