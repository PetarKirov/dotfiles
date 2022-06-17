function docker-pull-run --argument-names container_name image_name
    docker kill $container_name; or true
    docker pull $image_name
    and docker run -p 3000:80 --rm -d --name $container_name $image_name
end
