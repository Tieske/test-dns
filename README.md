test files to test DNS for Kong CE 0.12.1 / EE 0.30


Usage:
======

Run it on a system that has Kong installed (it requires some Kong dependencies).

```
/usr/local/openresty/bin/resty ./test.lua <name> [type]
```

- `<name>` is the name to resolve (required)
- `type` is the record type to look for; `A, SRV, CNAME` (optional)

If type is not specified, it will search for multiple types.

The exit code will be 0 on a succesful lookup, or 1 if it failed.

Typical output:
===============
```
$ ./test.lua srvtest.thijsschreijer.nl
========================= srvtest.thijsschreijer.nl =========================
Query:  (43 bytes)
b2 e7  1  0  0  1  0  0    0  0  0  0  7 73 72 76  ��...... .....srv
74 65 73 74  e 74 68 69   6a 73 73 63 68 72 65 69  test.thi jsschrei
6a 65 72  2 6e 6c  0  0   21  0  1                 jer.nl.. !..

UDP answer:  (142 bytes)
b2 e7 81 80  0  1  0  3    0  0  0  0  7 73 72 76  �灀.... .....srv
74 65 73 74  e 74 68 69   6a 73 73 63 68 72 65 69  test.thi jsschrei
6a 65 72  2 6e 6c  0  0   21  0  1 c0  c  0 21  0  jer.nl.. !..�..!.
 1  0  0  0 2d  0 11  0    a  0  5 1f 40  2 31 30  ....-... ....@.10
 1 30  1 30  2 34 33  0   c0  c  0 21  0  1  0  0  .0.0.43. �..!....
 0 2d  0 11  0 14  0  a   1f 40  2 31 30  1 30  1  .-...... .@.10.0.
30  2 34 34  0 c0  c  0   21  0  1  0  0  0 2d  0  0.44.�.. !.....-.
1d  0  a  0  5 1f 41  3   77 77 77  e 74 68 69 6a  ......A. www.thij
73 73 63 68 72 65 69 6a   65 72  2 6e 6c  0        sschreij er.nl.

{
  try_list = [[

	(short)srvtest.thijsschreijer.nl:(na) - cache-miss
	srvtest.thijsschreijer.nl:33 - cache-miss/scheduled/querying
	]],
  answer = {
    {
      class = 1,
      name = "srvtest.thijsschreijer.nl",
      target = "10.0.0.43",
      priority = 10,
      port = 8000,
      weight = 5,
      ttl = 45,
      section = 1,
      type = 33
    },
    {
      class = 1,
      name = "srvtest.thijsschreijer.nl",
      target = "10.0.0.44",
      priority = 20,
      port = 8000,
      weight = 10,
      ttl = 45,
      section = 1,
      type = 33
    },
    {
      class = 1,
      name = "srvtest.thijsschreijer.nl",
      target = "www.thijsschreijer.nl",
      priority = 10,
      port = 8001,
      weight = 5,
      ttl = 45,
      section = 1,
      type = 33
    },
    expire = 1516885704.243,
    ttl = 45,
    touch = 1516885659.243,
    expired = false
  }
}
```