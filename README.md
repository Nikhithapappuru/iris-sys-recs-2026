# Monitoring:

The objective of this task is to monitor the working of the containers while running the application.

### Architecture:

cAdvisor -> Prometheus -> Grafana

- cAdvisor collects the container metrics.

Firstly, added the services Prometheus and grafana to the docker-compose.yml file
```
Added to docker-compose.yml 
 cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    container_name: cadvisor
    restart: always
    ports:
      - "8081:8080"
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    networks:
      - rails_network

  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    restart: always
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    networks:
      - rails_network

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    restart: always
    ports:
      - "3001:3000"
    volumes:
      - grafana_data:/var/lib/grafana
    networks:
      - rails_network
```

In the file promtheus.yml file , added
```
global:
  scrape_interval: 5s

scrape_configs:
  - job_name: "cadvisor"
    static_configs:
      - targets: ["cadvisor:8080"]
```
So that promethues scrapes metrics every 5 seconds from cAdvisor:8080 and stores time-series data.
This is a pull-based monitoring.

Next pulled and started the containers:
```
docker compose up –build
```
Next checked the target( in status ) in prometheus dashboard at
```
http://localhost:9090/targets
```
At `localhost:3000`, logged into grafana
Opened a new dashboard and added prometheus as the data source 
Prometheus URL `(http://prometheus:9090)` ( Not localhost:9090 since prometheus is running in a container and so is grafana)
And then added  a new visualization `(Docker monitoring)`
And given the PromQL query
```
rate(container_cpu_usage_seconds_total[1m]) 
```
Where per-second increase in  cummulative CPU time used by the container is calculated over last 1 minute.

And then added a new visualization `(Memory Usage)`
Given PromQL query:
```
container_memory_usage_bytes
```

Added new visualization `(Network receive rate)` and given PromQL query:
```
container_network_receive_bytes_total[1m]
```

Added new visualization `(Running container count)` dashboard and given PromQL query:
```
 count(container_last_seen)
```
Which gives all the infrastructure containers.


Grafana connects to Prometheus as a data source and visualizes metrics via PromQL queries.
