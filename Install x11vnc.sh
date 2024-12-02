if [ "$(id -u)" != "0" ]; then
    echo "Voce deve executar este script como root! "
else
    sudo apt install x11vnc -y && sudo x11vnc -storepasswd 01591046 /root/.vncpasswd && sudo ufw allow 5900 && sudo ufw reload
​    # 2 Criar o arquivo de execução do x11vnc, inserir o comando de inicialização e dar permissões de execução
    sudo touch /bin/start_x11vnc.sh
    echo x11vnc -find -env FD_XDM=1 -auth guess -forever -rfbauth /root/.vncpasswd >> /bin/start_x11vnc.sh
    chmod 775 /bin/start_x11vnc.sh
​    # 3 Criar o arquivo de serviço do x11vnc e inserir os parâmetros
    sudo touch /etc/systemd/system/exec-x11vnc.service
    echo [Unit] >> /etc/systemd/system/exec-x11vnc.service
    echo Description="iniciar x11vnc" >> /etc/systemd/system/exec-x11vnc.service
    echo After=network.target >> /etc/systemd/system/exec-x11vnc.service
    echo " " >> /etc/systemd/system/exec-x11vnc.service
    echo [Service] >> /etc/systemd/system/exec-x11vnc.service
    echo Type=simple >> /etc/systemd/system/exec-x11vnc.service
    echo ExecStart=/bin/bash /bin/start_x11vnc.sh >> /etc/systemd/system/exec-x11vnc.service
    echo TimeoutStartSec=0 >> /etc/systemd/system/exec-x11vnc.service
    echo " " >> /etc/systemd/system/exec-x11vnc.service
    echo [Install]  >> /etc/systemd/system/exec-x11vnc.service
    echo WantedBy=default.target >> /etc/systemd/system/exec-x11vnc.service
​    # Recarregar o systemctl, habilitando o serviço criado e reiniciando
    sudo systemctl daemon-reload && sudo systemctl enable exec-x11vnc.service && reboot
fi
