import os

# 获取终端的大小
terminal_size = os.get_terminal_size().columns

# 消息
print()
message = "Super-Auto-HybPiper"

# 计算居中对齐的空格数量
left_spaces = (terminal_size - len(message)) // 2

# 定义颜色渐变范围
gradient_colors = [(41 + i) for i in range(0, 6)]

# 打印渐变色的每一行
for color in gradient_colors:
    # 设置字体颜色和背景颜色，然后打印消息
    print('\033[1;97;' + str(color) + 'm' + ' ' * left_spaces + message + ' ' * left_spaces + '\033[0m')
    
message = """Welcome to use Super-Auto-HybPiper.sh!

This script was written by Yuxuan Liu, from Huazhong Argriculture University.

It is a bash script which can be used to resolve phylogenomic issues on the basis of HybPiper.

It will help you reconstruct phylogenetic trees using HybPiper easily and automatically.

If you have any questions, please contact me via email: 1281096224@qq.com.

-------------------------------------------------------------------------------------------------

"""

# 按行拆分消息
lines = message.split('\n')

# 设置字体颜色和加粗效果，然后打印消息
print('\033[1;97m')  # 设置字体颜色为白色并加粗
for line in lines:
    # 计算居中对齐的空格数量
    left_spaces = (terminal_size - len(line)) // 2
    # 居中对齐打印每一行
    print(' ' * left_spaces + line)
print('\033[0m')  # 恢复默认字体属性