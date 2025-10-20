#!/bin/bash
set -e

# 创建必要的目录
mkdir -p $PREFIX/bin
mkdir -p $PREFIX/share/${PKG_NAME}/bin
mkdir -p $PREFIX/share/${PKG_NAME}/config
mkdir -p $PREFIX/share/${PKG_NAME}/dependencies

# 使用$SRC_DIR环境变量替代绝对路径（conda构建时自动设置）
cp $SRC_DIR/bin/HybSuite.sh $PREFIX/bin/
cp -r $SRC_DIR/bin/*.py $PREFIX/share/${PKG_NAME}/bin/
cp -r $SRC_DIR/bin/*.R $PREFIX/share/${PKG_NAME}/bin/
cp -r $SRC_DIR/config/* $PREFIX/share/${PKG_NAME}/config/
cp -r $SRC_DIR/dependencies/* $PREFIX/share/${PKG_NAME}/dependencies/

chmod +x $PREFIX/bin/HybSuite.sh
chmod -R 777 $PREFIX/share/${PKG_NAME}/
ln -s $PREFIX/bin/HybSuite.sh $PREFIX/bin/hybsuite

# 创建post-link脚本
cat > $PREFIX/bin/.post-link.sh << 'EOF'
#!/bin/bash
set -e
"$PREFIX/bin/pip" install --no-deps phylopypruner
echo "Welcome to use HybSuite! All HybSuite dependencies installed successfully!" >> $PREFIX/.messages.txt
EOF
chmod +x $PREFIX/bin/.post-link.sh

# 使用兼容macOS和Linux的sed方式
# 检测操作系统类型
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s|script_dir=.*|script_dir=\"$PREFIX/share/${PKG_NAME}/bin\"|g" $PREFIX/bin/HybSuite.sh
    sed -i '' "s|config_dir=.*|config_dir=\"$PREFIX/share/${PKG_NAME}/config\"|g" $PREFIX/bin/HybSuite.sh
    sed -i '' "s|dependencies_dir=.*|dependencies_dir=\"$PREFIX/share/${PKG_NAME}/dependencies\"|g" $PREFIX/bin/HybSuite.sh
else
    # Linux
    sed -i "s|script_dir=.*|script_dir=\"$PREFIX/share/${PKG_NAME}/bin\"|g" $PREFIX/bin/HybSuite.sh
    sed -i "s|config_dir=.*|config_dir=\"$PREFIX/share/${PKG_NAME}/config\"|g" $PREFIX/bin/HybSuite.sh
    sed -i "s|dependencies_dir=.*|dependencies_dir=\"$PREFIX/share/${PKG_NAME}/dependencies\"|g" $PREFIX/bin/HybSuite.sh
fi