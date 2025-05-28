# Prometheus-Grafana Observability Stack

A production-ready, containerized observability stack template, derived from a live setup, featuring Prometheus, Grafana, Traefik, and OpenTelemetry Collector. This stack provides comprehensive monitoring, metrics collection, visualization, and distributed tracing capabilities with enterprise-grade security and performance optimizations.

## 🏗️ Architecture

This observability stack consists of the following components:

- **Prometheus** - Time-series database and monitoring system for metrics collection
- **Grafana Enterprise** - Advanced visualization and dashboarding platform
- **Traefik v3** - Modern reverse proxy with automatic HTTPS/TLS termination
- **Node Exporter** - System metrics collector for host monitoring
- **OpenTelemetry Collector** - Unified telemetry data collection and processing
- **Loki** - Log aggregation system (configured separately)

## ✨ Features

### 🔒 Security & Performance
- **Automatic HTTPS/TLS** with Let's Encrypt certificate management
- **Basic Authentication** protection for all services
- **Performance optimizations** including compression, caching, and HTTP/2
- **Secure cookie handling** with SameSite and Secure flags
- **User/Group isolation** with configurable UID/GID

### 🚀 High Availability
- **Health checks** for all services with automatic recovery
- **Rolling updates** with failure rollback capabilities
- **Persistent data storage** with local volume bindings
- **Service dependencies** and startup ordering
- **Restart policies** with exponential backoff

### 📊 Monitoring Capabilities
- **System metrics** via Node Exporter
- **Application metrics** via Prometheus
- **Distributed tracing** via OpenTelemetry
- **Log aggregation** via Loki integration
- **Custom dashboards** with persistent storage

### 🌐 Network Architecture
- **Reverse proxy routing** with path-based routing
- **Overlay networking** for service communication
- **External access** only through Traefik (ports 80/443)
- **Internal service discovery** via Docker networks

## 📋 Prerequisites

- Docker Engine 20.10+ with Swarm mode enabled
- Docker Compose v2.0+
- Make utility
- Minimum 4GB RAM and 2 CPU cores
- Domain name with DNS pointing to your server (for production)

## 🚀 Quick Start

### 1. Clone and Setup

```bash
git clone <repository-url>
cd prom-grafana-observability-stack
```

### 2. Environment Configuration

```bash
# Copy environment template
cp .env-example .env

# Edit environment variables
nano .env
```

Required environment variables:
```env
GRAFANA_ADMIN_USER=admin
GRAFANA_ADMIN_PASSWORD=your-secure-password
TRAEFIK_ADMIN_USER=admin
TRAEFIK_ADMIN_PASSWORD=your-secure-password
```

### 3. Initialize Docker Swarm (if not already done)

```bash
docker swarm init
```

### 4. Create Required Secrets

```bash
# Create Prometheus master token secret
echo "your-prometheus-token" | docker secret create prometheus_master_token -
```

### 5. Deploy the Stack

```bash
# Initialize data directories and deploy
make up

# Or step by step:
make init  # Create data directories
make up    # Deploy the stack
```

## 🛠️ Available Commands

The project includes a comprehensive Makefile with the following commands:

```bash
make help      # Show all available commands
make init      # Create necessary data directories
make up        # Deploy the stack
make down      # Remove the stack
make restart   # Restart the stack (down + up)
make ps        # List running services
make logs      # Show logging instructions
make clean     # Clean up Docker resources
make dev       # Deploy stack for development
```

## 🌐 Service Access

Once deployed, services are accessible via:

### Production (with domain)
- **Traefik Dashboard**: `https://monitoring.yourdomain.com/`
- **Grafana**: `https://monitoring.yourdomain.com/grafana`
- **Prometheus**: `https://monitoring.yourdomain.com/prometheus`

### Development (localhost)
- **Traefik Dashboard**: `http://localhost:8080`
- **Grafana**: `http://localhost:3000`
- **Prometheus**: `http://localhost:9090`

## 📁 Directory Structure

```
├── docker-stack.yml          # Main Docker Swarm stack definition
├── Makefile                  # Automation commands
├── .env-example              # Environment variables template
├── prometheus/
│   └── prometheus.yml        # Prometheus configuration
├── grafana/
│   ├── datasources/          # Grafana datasource configurations
│   └── dashboards/           # Dashboard provisioning
├── traefik/
│   ├── traefik.yml          # Traefik static configuration
│   ├── dynamic/             # Dynamic configuration files
│   └── acme.json.example    # Let's Encrypt certificate storage
├── otel-collector/
│   └── config.yaml          # OpenTelemetry Collector configuration
└── loki/                    # Loki log aggregation configuration
```

## ⚙️ Configuration

### Prometheus Configuration
- **Scrape targets**: Configured in `prometheus/prometheus.yml`
- **Retention**: Default 15 days (configurable)
- **Storage**: Persistent volume at `/home/tofara/data/prometheus`

### Grafana Configuration
- **Datasources**: Auto-provisioned from `grafana/datasources/`
- **Dashboards**: Auto-provisioned from `grafana/dashboards/`
- **Plugins**: Enterprise features enabled
- **Storage**: Persistent volume at `/home/tofara/data/grafana`

### Traefik Configuration
- **Static config**: `traefik/traefik.yml`
- **Dynamic config**: `traefik/dynamic/` directory
- **Certificates**: Automatic Let's Encrypt with HTTP challenge
- **Middlewares**: Compression, caching, authentication

### OpenTelemetry Configuration
- **Receivers**: OTLP, Prometheus, Jaeger
- **Processors**: Batch processing, resource detection
- **Exporters**: Prometheus, Jaeger, logging
- **Storage**: Persistent volume at `/home/tofara/data/otel-collector`

## 🔧 Customization

### Adding New Services
1. Add service definition to `docker-stack.yml`
2. Configure Traefik labels for routing
3. Add health checks and restart policies
4. Update network configuration

### Custom Dashboards
1. Place JSON dashboard files in `grafana/dashboards/json/`
2. Configure dashboard provider in `grafana/dashboards/`
3. Restart Grafana service

### SSL/TLS Configuration
1. Update domain names in Traefik labels
2. Configure DNS to point to your server
3. Ensure ports 80/443 are accessible
4. Let's Encrypt will automatically provision certificates

## 🔍 Monitoring and Troubleshooting

### Service Status
```bash
# Check service status
make ps

# View service logs
docker service logs monitoring_prometheus
docker service logs monitoring_grafana
docker service logs monitoring_traefik
```

### Health Checks
All services include comprehensive health checks:
- **Prometheus**: `/prometheus/-/healthy`
- **Grafana**: `/api/health`
- **Traefik**: `/metrics`
- **Node Exporter**: `/metrics`
- **OpenTelemetry**: Health check endpoint

### Common Issues
1. **Permission errors**: Ensure data directories have correct ownership
2. **Certificate issues**: Verify DNS configuration and port accessibility
3. **Service startup**: Check Docker Swarm status and resource availability
4. **Network connectivity**: Verify overlay network configuration

## 📊 Default Metrics and Dashboards

### Included Metrics
- **System metrics**: CPU, memory, disk, network via Node Exporter
- **Container metrics**: Docker container statistics
- **Application metrics**: Custom application metrics via Prometheus
- **Traefik metrics**: Request rates, response times, error rates

### Pre-configured Dashboards
- Node Exporter system metrics
- Docker container monitoring
- Traefik performance metrics
- Custom application dashboards

## 🔐 Security Considerations

- All services run with non-root users
- Basic authentication on all external endpoints
- HTTPS/TLS encryption for all external traffic
- Secure cookie configuration
- Network isolation via Docker overlay networks
- Regular security updates via automated image pulls

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For issues and questions:
1. Check the troubleshooting section
2. Review service logs
3. Open an issue with detailed information
4. Include environment details and error messages
