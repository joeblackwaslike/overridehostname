# overridehostname

This project was created in order to override calls to `gethostname(2)` and `sethostname(2)` of libc.  This is mainly useful inside docker containers for situations where you cannot control the conditions in which the container was originally started in a similarly useful way, such as under kubernetes.


Some applications, especially erlang applications, impose requirements that make running them under kubernetes extremely difficult and this is the usecase this was designed for.  Although this can also be achieved by running the container with the `SYS_ADMIN` capability, I felt that is a rather unacceptable compromise.


## Installation
* Place liboverridehostname.so.1 somewhere easy to remember.  I use `/usr/local/lib/` personally.
* Add the entire path to the library to LD_PRELOAD and export. Example: `export LD_PRELOAD=/usr/local/lib/liboverridehostname.so.1` *this alone does not activate the library.*

## Activation
* Export `OVERRIDE_HOSTNAME=true` to your environment.  Example: `export OVERRIDE_HOSTNAME=true`.

## Changing the hostname
```bash
hostname <new-hostname>
```

## Don't forget
* To add the hostname and FQDN to /etc/hosts
```bash
echo "<ip.add.re.ss>    <new-hostname-fqdn> <new-hostname>" >> /etc/hosts
```

* To remove the old hostname if you aren't using it anymore
```bash
sed "/$OLD_HOSTNAME/d" /etc/hosts
```

**Under docker this is harder, but the following will work**
```bash
echo "$(sed "/$OLD_HOSTNAME/d" /etc/hosts)" > /etc/hosts
```
