docker run -d \
  -p 9000:9000 \
  --name Portainer_9000 \
  --restart unless-stopped \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v Portainer_9000_Data:/data portainer/portainer \
  -H unix:///var/run/docker.sock \
  --admin-password='$2y$05$phwSg3ykaHLBDYEEpUHfFeePAlN52B5jX.EOS4GsVPtr9wd008iSO' \
  --templates "https://raw.githubusercontent.com/joelrader-ping/portainer-templates/master/templates-ping.json" \
  --logo "https://raw.githubusercontent.com/joelrader-ping/portainer-templates/master/ping-logo.svg"
