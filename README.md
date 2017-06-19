# Nagios-Elasticpulse
I got tired of not having the plugins i wanted so i am making a series of Nagios plugins to check the document counts in an Elasticsearch index. It will tell me if a job stops indexing documents in a given timespan...

## Example of a rule i Nagios.
I removed the .sh extension and moved it to the /usr/local/nagios/libexec folder.

I also made it executeable bu Nagios

`chmod +x /usr/local/nagios/libexec/elasticpulse_indexcount`

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
    command_name    check_indexactive
    command_line    $USER1$/elasticpulse_indexcount
}

define service{
        use                     generic-service
        host_name               myelasticserver
        service_description     Test_plugin
        check_command           check_indexactive
}
```