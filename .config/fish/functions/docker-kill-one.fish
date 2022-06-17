function docker-kill-one
    test (docker ps | tail -n +2 | wc -l) -eq 1 \
        && docker kill (docker ps | tail -n +2 | awk '{print $1}') \
        || true
end
