#!/bin/bash
#
# Cycle in background and poll database for failed SVEs.
# Once detected, offline the test and exit;
#


export PGPASSWORD=variant
variant_home=/tmp/server/variant-server-0.9.2
feature_name=VetsHourlyRateFeature

while true; do

	event_count=$(psql -X -A  -U variant -t -c \
		"select count(*) from events e, event_experiences ee, event_attributes a \
		 where e.id = ee.event_id and e.id = a.event_id \
		 and ee.test_name = '$feature_name' and ee.experience_name = 'rateColumn' \
		 and a.key = '\$STATUS' and a.value = 'Failed';" \
		)
		
	if [ $event_count -gt 0 ]; then
		
		echo "Detected $event_count failed SVE(s) in the trace log. Feature '$feature_name' is going offline."
	
		## In the future, we will simply say "ALTER VARIATION $feature_name OFFLINE"
		## For now, just stream-edit the schema in place and let it hot-redeploy.
		
		sed -E "/${feature_name}/ s/$/ 'isOn':false,/" ${variant_home}/schemata/petclinic.schema > /tmp/foo
		mv /tmp/foo ${variant_home}/schemata/petclinic.schema
	
	    exit
	else
	    echo "No failed SVE(s) in Variant trace log. Sleeping 5 seconds."
	    sleep 5
	fi
		
done