$TTL    3600
@       IN      SOA     ns.asircastelao.com. sromerodiaz.danielcastelao.org. (
                   2022051001           ; Serial
                         3600           ; Refresh [1h]
                          600           ; Retry   [10m]
                        86400           ; Expire  [1d]
                          600 )         ; Negative Cache TTL [1h]
;
@       IN      NS      ns.asircastelao.com.
@       IN      MX      10 maquinita.asircastelao.org.

ns     IN      A       94.1.4.2
etch    IN      A       123.23.1.4

pop.asircastelao.com.     IN      CNAME   ns
www.asircastelao.com.     IN      CNAME   etch
mail.asircastelao.com.    IN      CNAME   etch
