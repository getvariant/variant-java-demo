#/bin/bash

toggle_is_on=true

while $toggle_is_on; do
echo foo
toggle_is_on=false
done 

export PGPASSWORD=variant
event_count=$(psql -U variant -P t -P format=unaligned -c "SELECT count(*) FROM events")
echo $event_count