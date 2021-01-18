An API for creation of users and songs, rating of songs, unique views, and more.

## Stack
- [roda](https://github.com/jeremyevans/roda)
- [sequel](https://github.com/jeremyevans/sequel)
- [postgres](https://www.postgresql.org/)

## Create db user

```
sudo -u {username} createuser {user name}
```

## Create db

```
createdb -U {username} -O {user name} {db name}
```

### Rake Tasks

Init Dev DB
```
rake dev_up
```

Tear down Dev DB
```
rake dev_down
```
