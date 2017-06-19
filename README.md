# Nagios-Elasticpulse
I got tired of not having the plugins i wanted so i am making a series of Nagios plugins to check the document counts in an Elasticsearch index. It will tell me if a job stops indexing documents in a given timespan...

## Example of a rule i Nagios.
I removed the .sh extension and moved it to the /usr/local/nagios/libexec folder.

I also made it executeable by Nagios

`chmod +x /usr/local/nagios/libexec/elasticpulse_indexcount`

## The script takes/needs the following arguments.
- -H = Elastic hostname eg. elastic.mydomain.com or 192.168.0.55:9200.
- -t = Timeback, the amount of time to look back when counting new entries.
- -u = Credentials, username and password eg. elastic:changeme.
- -i = Indexname eg. notifications
- -t = datatype of your index eg. logdata or serverdata

```sh
define host{
    name                    myelasticserver
    host_name               myelasticserver
    use                     generic-host
    address                 192.168.0.55
    check_period            24x7
    check_interval          10
    retry_interval          3
    max_check_attempts      5
    notification_period     24x7
    notification_options    d,u,r
    notification_interval   360
    contact_groups          mycontacts
    check_command           check-host-alive
}

define command{
    command_name            check_indexactive
    command_line            $USER1$/elasticpulse_indexcount -H $ARG1$ -t $ARG2$ -u $ARG3$ -i $ARG4$ -d $ARG5$
}

define service{
    use                     generic-service
    host_name               myelasticserver
    service_description     check_index
    check_command           check_indexactive!elastic.mydomain.com!15m!elastic:changeme!notifications!logdata
}
```