Install dependencies
```bash
bundle install
```

To spin up an instance
```bash
rake spinup:run
```

To view the running instances
```bash
rake spinup:list
```

To stop the running instances
```bash
rake spinup:stop_all
```

Notes
1. The default secuty group needs to have an SSH enabled on port 22
