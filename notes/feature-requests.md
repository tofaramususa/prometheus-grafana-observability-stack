- fail2ban --> block IPs with too many failed login attempts
- everyrequest passes through Auth middleware/ username and password DONE
- API requires token access

Application Specific:
- Make use of Docker Swarm DONE
- Deploy all your projects on a single VPS
- Load balance multiple container per project
- Deploy preview environments with ease
- Manage env secrets in a secure way
- Connect any number of domains and subdomains to your projects with ease


Ideas:
- Keep Alert Logic in Grafana and Keep observaility logic in a single place -- config file


Notes:
- A dashboard is just a JSON file that you can search for in Google and load to the mounted folder



LOAD BALANCING and HIGH AVAILABILITY
- Use of load balancing: with keyword for docker compose.
deploy:
 mode: replicated
 replicas: 3

AUTOMATED DEPLOYMENT with WATCHTOWER:
- - Deploy new versions with Zero downtime -- may use Watchtower together with a container registry


UPTIME MONITOR with Sentry
