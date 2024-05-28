#!/bin/bash

# 设置数据库连接参数
DB_USER="your_db_user"
DB_PASS="your_db_password"
MASTER_HOST="master_host"
SLAVE_HOST="slave_host"

# 查询主从服务器的复制状态
MASTER_LOG_FILE=$(mysql -u$DB_USER -p$DB_PASS -h $MASTER_HOST -e "SHOW MASTER STATUS\G" | grep File | awk '{print $2}')
MASTER_LOG_POS=$(mysql -u$DB_USER -p$DB_PASS -h $MASTER_HOST -e "SHOW MASTER STATUS\G" | grep Position | awk '{print $2}')
SLAVE_STATUS=$(mysql -u$DB_USER -p$DB_PASS -h $SLAVE_HOST -e "SHOW SLAVE STATUS\G")

# 提取从服务器的复制信息
SLAVE_IO_RUNNING=$(echo "$SLAVE_STATUS" | grep "Slave_IO_Running" | awk '{print $2}')
SLAVE_SQL_RUNNING=$(echo "$SLAVE_STATUS" | grep "Slave_SQL_Running" | awk '{print $2}')
SLAVE_LOG_FILE=$(echo "$SLAVE_STATUS" | grep "Relay_Master_Log_File" | awk '{print $2}')
SLAVE_LOG_POS=$(echo "$SLAVE_STATUS" | grep "Exec_Master_Log_Pos" | awk '{print $2}')

# 计算同步延迟
if [ "$SLAVE_IO_RUNNING" = "Yes" ] && [ "$SLAVE_SQL_RUNNING" = "Yes" ]; then
    DELAY=$(mysql -u$DB_USER -p$DB_PASS -h $SLAVE_HOST -e "SELECT (MASTER_POS_WAIT('$MASTER_LOG_FILE', $MASTER_LOG_POS, 10)) AS delay;" | grep delay | awk '{print $2}')
    echo "同步延迟为: $DELAY"
else
    echo "从服务器复制未正常运行"
fi
