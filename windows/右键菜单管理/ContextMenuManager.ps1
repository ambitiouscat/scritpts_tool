#requires -version 5.0
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Xaml

$IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# ----------------- XAML UI DESIGN (Premium Borderless Dark Theme) -----------------
$xamlContent = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Windows 10 右键菜单管理工具" Height="580" Width="820"
        WindowStartupLocation="CenterScreen" Background="Transparent"
        AllowsTransparency="True" WindowStyle="None" ResizeMode="NoResize">
    
    <Window.Resources>
        <!-- Styles for Filter Buttons -->
        <Style x:Key="FilterBtn" TargetType="Button">
            <Setter Property="Background" Value="#212126"/>
            <Setter Property="Foreground" Value="#A0A0A5"/>
            <Setter Property="FontSize" Value="10"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Height" Value="24"/>
            <Setter Property="Padding" Value="12,0"/>
            <Setter Property="Margin" Value="0,0,8,0"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="BorderBrush" Value="#2D2D34"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="12">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" Margin="{TemplateBinding Padding}"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#2A2A30"/>
                                <Setter Property="Foreground" Value="#FFFFFF"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        
        <Style x:Key="FilterBtnActive" TargetType="Button">
            <Setter Property="Background" Value="#7C4DFF"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="FontSize" Value="10"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Height" Value="24"/>
            <Setter Property="Padding" Value="12,0"/>
            <Setter Property="Margin" Value="0,0,8,0"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border" Background="{TemplateBinding Background}" CornerRadius="12">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" Margin="{TemplateBinding Padding}"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- Styles for Sidebar Buttons -->
        <Style x:Key="SidebarBtn" TargetType="Button">
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Foreground" Value="#A0A0A5"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Height" Value="42"/>
            <Setter Property="Margin" Value="0,4,0,4"/>
            <Setter Property="Padding" Value="15,0,0,0"/>
            <Setter Property="HorizontalContentAlignment" Value="Left"/>
            <Setter Property="VerticalContentAlignment" Value="Center"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border" Background="{TemplateBinding Background}" CornerRadius="6" BorderThickness="0">
                            <ContentPresenter HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}" 
                                              VerticalAlignment="{TemplateBinding VerticalContentAlignment}" 
                                              Margin="{TemplateBinding Padding}"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#25252A"/>
                                <Setter Property="Foreground" Value="#FFFFFF"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        
        <Style x:Key="SidebarBtnActive" TargetType="Button">
            <Setter Property="Background" Value="#2A2244"/>
            <Setter Property="Foreground" Value="#B388FF"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Height" Value="42"/>
            <Setter Property="Margin" Value="0,4,0,4"/>
            <Setter Property="Padding" Value="15,0,0,0"/>
            <Setter Property="HorizontalContentAlignment" Value="Left"/>
            <Setter Property="VerticalContentAlignment" Value="Center"/>
            <Setter Property="BorderThickness" Value="3,0,0,0"/>
            <Setter Property="BorderBrush" Value="#7C4DFF"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border" Background="{TemplateBinding Background}" CornerRadius="0,6,6,0" 
                                BorderThickness="{TemplateBinding BorderThickness}" BorderBrush="{TemplateBinding BorderBrush}">
                            <ContentPresenter HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}" 
                                              VerticalAlignment="{TemplateBinding VerticalContentAlignment}" 
                                              Margin="{TemplateBinding Padding}"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- Styles for Form Buttons -->
        <Style x:Key="PrimaryBtn" TargetType="Button">
            <Setter Property="Background" Value="#7C4DFF"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Height" Value="32"/>
            <Setter Property="Padding" Value="12,0"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border" Background="{TemplateBinding Background}" CornerRadius="4">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#9575CD"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#673AB7"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="ActionBtn" TargetType="Button">
            <Setter Property="Background" Value="#7C4DFF"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Height" Value="40"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border" Background="{TemplateBinding Background}" CornerRadius="6">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#9575CD"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="border" Property="Background" Value="#673AB7"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- Style for custom inputs -->
        <Style x:Key="TextBoxBorder" TargetType="Border">
            <Setter Property="Background" Value="#212126"/>
            <Setter Property="BorderBrush" Value="#2D2D34"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="CornerRadius" Value="4"/>
            <Setter Property="Height" Value="32"/>
            <Setter Property="Padding" Value="5,0"/>
        </Style>
    </Window.Resources>
    
    <!-- Window main border with soft border and rounded corners -->
    <Border CornerRadius="12" Background="#18181C" BorderBrush="#2D2D34" BorderThickness="1">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="40"/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            
            <!-- Beautiful Header / Title Bar -->
            <Border Grid.Row="0" Background="#111114" CornerRadius="11,11,0,0" Name="TitleBar">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="Auto"/>
                    </Grid.ColumnDefinitions>
                    
                    <StackPanel Orientation="Horizontal" Grid.Column="0" VerticalAlignment="Center" Margin="15,0,0,0">
                        <TextBlock Text="★" Foreground="#7C4DFF" FontSize="14" VerticalAlignment="Center" Margin="0,0,8,0"/>
                        <TextBlock Text="Windows 10 右键菜单管理工具" Foreground="#E2E2E6" FontSize="13" FontWeight="SemiBold" VerticalAlignment="Center"/>
                    </StackPanel>
                    
                    <StackPanel Orientation="Horizontal" Grid.Column="1" VerticalAlignment="Center" Margin="0,0,10,0">
                        <Button Name="BtnMinimize" Content="—" Width="30" Height="25" Background="Transparent" Foreground="#A0A0A5" BorderThickness="0" Margin="0,0,5,0">
                            <Button.Style>
                                <Style TargetType="Button">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="Button">
                                                <Border x:Name="b" Background="Transparent" CornerRadius="4">
                                                    <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                                </Border>
                                                <ControlTemplate.Triggers>
                                                    <Trigger Property="IsMouseOver" Value="True">
                                                        <Setter TargetName="b" Property="Background" Value="#25252A"/>
                                                    </Trigger>
                                                </ControlTemplate.Triggers>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </Style>
                            </Button.Style>
                        </Button>
                        <Button Name="BtnClose" Content="✕" Width="30" Height="25" Background="Transparent" Foreground="#A0A0A5" BorderThickness="0">
                            <Button.Style>
                                <Style TargetType="Button">
                                    <Setter Property="Template">
                                        <Setter.Value>
                                            <ControlTemplate TargetType="Button">
                                                <Border x:Name="b" Background="Transparent" CornerRadius="4">
                                                    <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                                </Border>
                                                <ControlTemplate.Triggers>
                                                    <Trigger Property="IsMouseOver" Value="True">
                                                        <Setter TargetName="b" Property="Background" Value="#E53935"/>
                                                        <Setter Property="Foreground" Value="White"/>
                                                    </Trigger>
                                                </ControlTemplate.Triggers>
                                            </ControlTemplate>
                                        </Setter.Value>
                                    </Setter>
                                </Style>
                            </Button.Style>
                        </Button>
                    </StackPanel>
                </Grid>
            </Border>
            
            <!-- Window Client Body -->
            <Grid Grid.Row="1">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="185"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                
                <!-- Left Sidebar Navigation -->
                <Border Grid.Column="0" Background="#111114" CornerRadius="0,0,0,11" BorderBrush="#2D2D34" BorderThickness="0,0,1,0">
                    <Grid>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="Auto"/>
                        </Grid.RowDefinitions>
                        
                        <StackPanel Grid.Row="0" Margin="10,20,10,10">
                            <Button Name="NavBtnAdd" Content="  +  添加右键菜单" Style="{StaticResource SidebarBtnActive}"/>
                            <Button Name="NavBtnManage" Content="  *  菜单管理" Style="{StaticResource SidebarBtn}"/>
                            <Button Name="NavBtnAbout" Content="  i  关于工具" Style="{StaticResource SidebarBtn}"/>
                        </StackPanel>
                        
                        <!-- Dynamic Status Indicator -->
                        <Border Grid.Row="1" Margin="12" Padding="10" CornerRadius="6" Background="#1E281E" Name="StatusPanel">
                            <StackPanel>
                                <TextBlock Text="运行状态" Foreground="#707075" FontSize="10" FontWeight="Bold" Margin="0,0,0,4"/>
                                <TextBlock Name="TxtPrivilegeStatus" Text="普通用户模式" Foreground="#81C784" FontSize="11" FontWeight="SemiBold"/>
                                <TextBlock Name="TxtPrivilegeDesc" Text="修改个人菜单 (安全)" Foreground="#707075" FontSize="9" Margin="0,2,0,0"/>
                            </StackPanel>
                        </Border>
                    </Grid>
                </Border>
                
                <!-- Right Side Workspace Panel -->
                <Grid Grid.Column="1" Margin="25">
                    
                    <!-- 1. ADD MENU PANEL -->
                    <Grid Name="PanelAdd" Visibility="Visible">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>
                        
                        <StackPanel Grid.Row="0" Margin="0,0,0,15">
                            <TextBlock Text="添加自定义右键菜单" Foreground="White" FontSize="18" FontWeight="Bold"/>
                            <TextBlock Text="无损添加文件、文件夹或空白处的右键快速访问项目" Foreground="#A0A0A5" FontSize="11" Margin="0,3,0,0"/>
                        </StackPanel>
                        
                        <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled">
                            <StackPanel Margin="0,0,12,0">
                                <!-- Menu Title Input -->
                                <TextBlock Text="菜单显示名称 (如：用 VS Code 打开)" Foreground="#E2E2E6" FontSize="12" FontWeight="SemiBold" Margin="0,0,0,6"/>
                                <Border Style="{StaticResource TextBoxBorder}" Margin="0,0,0,15">
                                    <TextBox Name="TxtMenuName" Background="Transparent" Foreground="White" BorderThickness="0" 
                                             VerticalAlignment="Center" CaretBrush="White" Padding="3,0"/>
                                </Border>
                                
                                <!-- Executable Path Picker -->
                                <TextBlock Text="目标应用路径 (.exe, .bat, .cmd 等)" Foreground="#E2E2E6" FontSize="12" FontWeight="SemiBold" Margin="0,0,0,6"/>
                                <Grid Margin="0,0,0,15">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="Auto"/>
                                    </Grid.ColumnDefinitions>
                                    <Border Grid.Column="0" Style="{StaticResource TextBoxBorder}">
                                        <TextBox Name="TxtAppPath" Background="Transparent" Foreground="White" BorderThickness="0" 
                                                 VerticalAlignment="Center" CaretBrush="White" Padding="3,0"/>
                                    </Border>
                                    <Button Name="BtnBrowseApp" Grid.Column="1" Content="浏览..." Style="{StaticResource PrimaryBtn}" Margin="8,0,0,0"/>
                                </Grid>
                                
                                <!-- Icon Path Picker (Optional) -->
                                <TextBlock Text="自定义图标路径 (可选，留空默认使用程序图标)" Foreground="#E2E2E6" FontSize="12" FontWeight="SemiBold" Margin="0,0,0,6"/>
                                <Grid Margin="0,0,0,15">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="Auto"/>
                                    </Grid.ColumnDefinitions>
                                    <Border Grid.Column="0" Style="{StaticResource TextBoxBorder}">
                                        <TextBox Name="TxtIconPath" Background="Transparent" Foreground="White" BorderThickness="0" 
                                                 VerticalAlignment="Center" CaretBrush="White" Padding="3,0"/>
                                    </Border>
                                    <Button Name="BtnBrowseIcon" Grid.Column="1" Content="浏览..." Style="{StaticResource PrimaryBtn}" Margin="8,0,0,0"/>
                                </Grid>
                                
                                <!-- Position selection and scope selection side-by-side -->
                                <Grid Margin="0,5,0,15">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    
                                    <!-- Options Checklist -->
                                    <StackPanel Grid.Column="0" Margin="0,0,10,0">
                                        <TextBlock Text="生效位置 (可多选)" Foreground="#E2E2E6" FontSize="12" FontWeight="SemiBold" Margin="0,0,0,8"/>
                                        <CheckBox Name="ChkTypeFile" Content="文件右键菜单" Foreground="#E2E2E6" Margin="0,0,0,6" IsChecked="True"/>
                                        <CheckBox Name="ChkTypeFolder" Content="文件夹右键菜单" Foreground="#E2E2E6" Margin="0,0,0,6" IsChecked="True"/>
                                        <CheckBox Name="ChkTypeBackground" Content="空白处右键菜单" Foreground="#E2E2E6" Margin="0,0,0,6"/>
                                    </StackPanel>
                                    
                                    <!-- Scope RadioButtons -->
                                    <StackPanel Grid.Column="1" Margin="10,0,0,0">
                                        <TextBlock Text="写入注册表范围" Foreground="#E2E2E6" FontSize="12" FontWeight="SemiBold" Margin="0,0,0,8"/>
                                        <RadioButton Name="RdoScopeUser" Content="仅当前用户 (安全/免权限)" Foreground="#E2E2E6" Margin="0,0,0,6" IsChecked="True"/>
                                        <RadioButton Name="RdoScopeGlobal" Content="系统全局 (需要管理员)" Foreground="#E2E2E6" Margin="0,0,0,6"/>
                                    </StackPanel>
                                </Grid>
                                
                                <!-- Success / Error Feedback Indicator -->
                                <TextBlock Name="TxtAddFeedback" Text="" Foreground="#81C784" FontSize="12" FontWeight="Bold" Margin="0,5,0,5" Visibility="Collapsed" HorizontalAlignment="Center"/>
                                
                                <!-- Trigger Button -->
                                <Button Name="BtnCreateMenu" Content="创建右键菜单项" Style="{StaticResource ActionBtn}" Margin="0,5,0,10"/>
                            </StackPanel>
                        </ScrollViewer>
                    </Grid>
                    
                    <!-- 2. MANAGE MENU PANEL (SCROLLABLE LIST) -->
                    <Grid Name="PanelManage" Visibility="Collapsed">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>
                        
                        <StackPanel Grid.Row="0" Margin="0,0,0,10">
                            <TextBlock Text="管理已添加的菜单" Foreground="White" FontSize="18" FontWeight="Bold"/>
                            <TextBlock Text="在这里安全扫描并删除您的自定义选项。删除操作会在同级目录下生成 .reg 备份。" Foreground="#A0A0A5" FontSize="11" Margin="0,3,0,0"/>
                        </StackPanel>
                        
                        <!-- Filter Tabs Row -->
                        <StackPanel Grid.Row="1" Orientation="Horizontal" Margin="0,0,0,15" Name="FilterBar">
                            <Button Name="BtnFilterAll" Content="全部" Style="{StaticResource FilterBtnActive}"/>
                            <Button Name="BtnFilterFile" Content="文件右键 (📄)" Style="{StaticResource FilterBtn}"/>
                            <Button Name="BtnFilterFolder" Content="文件夹右键 (📁)" Style="{StaticResource FilterBtn}"/>
                            <Button Name="BtnFilterBg" Content="空白处右键 (🖥️)" Style="{StaticResource FilterBtn}"/>
                        </StackPanel>
                        
                        <ScrollViewer Grid.Row="2" VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled">
                            <StackPanel Name="ListContainer" Margin="0,0,12,0">
                                <!-- Cards will load dynamically -->
                            </StackPanel>
                        </ScrollViewer>
                    </Grid>
                    
                    <!-- 3. ABOUT AND PRIVILEGE PANEL -->
                    <Grid Name="PanelAbout" Visibility="Collapsed">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>
                        
                        <StackPanel Grid.Row="0" Margin="0,0,0,15">
                            <TextBlock Text="关于本工具" Foreground="White" FontSize="18" FontWeight="Bold"/>
                            <TextBlock Text="保障您的注册表安全无忧" Foreground="#A0A0A5" FontSize="11" Margin="0,3,0,0"/>
                        </StackPanel>
                        
                        <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto">
                            <StackPanel Margin="0,0,15,0">
                                <Border Background="#212126" BorderBrush="#2D2D34" BorderThickness="1" CornerRadius="8" Padding="15" Margin="0,0,0,12">
                                    <StackPanel>
                                        <TextBlock Text="100% 绿色安全备份机制" Foreground="White" FontSize="14" FontWeight="Bold" Margin="0,0,0,8"/>
                                        <TextBlock Text="每次您在此工具中点击【删除】任何菜单项，工具都会自动在当前目录下生成一个名为 `backup_[项目名]_[时间戳].reg` 的注册表备份文件。" Foreground="#E2E2E6" FontSize="12" TextWrapping="Wrap" Margin="0,0,0,5"/>
                                        <TextBlock Text="如果发生误删或意外，您只需在文件夹中双击对应的 `.reg` 备份文件并选择导入，即可瞬间完整恢复该右键菜单项！无任何后顾之忧。" Foreground="#B388FF" FontSize="12" TextWrapping="Wrap" Margin="0,0,0,5"/>
                                    </StackPanel>
                                </Border>

                                <Border Background="#212126" BorderBrush="#2D2D34" BorderThickness="1" CornerRadius="8" Padding="15" Margin="0,0,0,12">
                                    <StackPanel>
                                        <TextBlock Text="菜单显示位置说明" Foreground="White" FontSize="14" FontWeight="Bold" Margin="0,0,0,8"/>
                                        <TextBlock Text="• 文件右键：在您右键点击任何【文件】时显示。" Foreground="#E2E2E6" FontSize="12" Margin="0,0,0,4"/>
                                        <TextBlock Text="• 文件夹右键：在您右键点击任何【文件夹】时显示。" Foreground="#E2E2E6" FontSize="12" Margin="0,0,0,4"/>
                                        <TextBlock Text="• 空白处右键：在某个目录的【空白处背景】或【桌面空白处】右键时显示。" Foreground="#E2E2E6" FontSize="12" Margin="0,0,0,4"/>
                                    </StackPanel>
                                </Border>

                                <Border Background="#212126" BorderBrush="#2D2D34" BorderThickness="1" CornerRadius="8" Padding="15" Margin="0,0,0,15">
                                    <StackPanel>
                                        <TextBlock Text="系统运行权限说明" Foreground="White" FontSize="14" FontWeight="Bold" Margin="0,0,0,8"/>
                                        <TextBlock Text="• 个人用户模式 (HKCU)：免权限安全执行，只对您当前电脑账户生效，极其推荐！" Foreground="#81C784" FontSize="12" Margin="0,0,0,4"/>
                                        <TextBlock Text="• 全局管理员模式 (HKCR)：需要管理员权限运行本工具，可修改对全机所有账户生效的全局右键菜单。" Foreground="#FFB74D" FontSize="12" Margin="0,0,0,4"/>
                                    </StackPanel>
                                </Border>

                                <Button Name="BtnRelaunchAdmin" Content="以管理员权限重新运行" Style="{StaticResource ActionBtn}" Width="250" HorizontalAlignment="Left"/>
                            </StackPanel>
                        </ScrollViewer>
                    </Grid>
                    
                </Grid>
            </Grid>
        </Grid>
    </Border>
</Window>
'@

# ----------------- PARSE AND LOAD WPF WINDOW -----------------
[xml]$xaml = $xamlContent
$reader = [System.Xml.XmlNodeReader]::new($xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

# Map WPF Named Elements to PowerShell Variables automatically
$xaml.SelectNodes("//*[@Name]") | ForEach-Object {
    Set-Variable -Name $_.Name -Value $window.FindName($_.Name) -Scope Script
}

# ----------------- BORDERLESS WINDOW MOVEMENT -----------------
$TitleBar.Add_MouseLeftButtonDown({
    $window.DragMove()
})

$BtnClose.Add_Click({
    $window.Close()
})

$BtnMinimize.Add_Click({
    $window.WindowState = [System.Windows.WindowState]::Minimized
})

# ----------------- ADMIN PRIVILEGE CONFIGURATION -----------------
if ($IsAdmin) {
    $TxtPrivilegeStatus.Text = "管理员权限模式"
    $TxtPrivilegeStatus.Foreground = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(255, 183, 77)) # Orange/Gold
    $StatusPanel.Background = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(45, 33, 20))
    $TxtPrivilegeDesc.Text = "可以管理全局右键菜单"
    $BtnRelaunchAdmin.Visibility = [System.Windows.Visibility]::Collapsed # Hide relaunch if already admin
} else {
    $TxtPrivilegeStatus.Text = "普通用户模式 (安全)"
    $TxtPrivilegeStatus.Foreground = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(129, 199, 132)) # Light green
    $StatusPanel.Background = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(26, 35, 26))
    $TxtPrivilegeDesc.Text = "修改个人菜单 (免提权)"
    
    # Disable global radio option
    $RdoScopeGlobal.IsEnabled = $false
    $RdoScopeGlobal.ToolTip = "需要管理员权限才能修改全局"
    $BtnRelaunchAdmin.Visibility = [System.Windows.Visibility]::Visible
}

# Administrative Relaunch
$BtnRelaunchAdmin.Add_Click({
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    try {
        Start-Process powershell -ArgumentList $arguments -Verb RunAs
        $window.Close()
    } catch {
        [System.Windows.Forms.MessageBox]::Show("无法以管理员身份启动：$($_.Exception.Message)", "授权失败", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

# ----------------- REGISTRY READ & BACKUP LOGIC -----------------
function Backup-RegistryKey {
    param (
        [string]$psPath,
        [string]$keyName
    )
    # Translate PowerShell Registry Provider path to standard Registry Syntax
    # e.g., Microsoft.PowerShell.Core\Registry::HKEY_CURRENT_USER\Software\... -> HKCU\Software\...
    $regPath = $psPath
    if ($regPath -match "HKEY_CURRENT_USER") {
        $regPath = $regPath -replace '^.*HKEY_CURRENT_USER', 'HKCU'
    } elseif ($regPath -match "HKEY_CLASSES_ROOT") {
        $regPath = $regPath -replace '^.*HKEY_CLASSES_ROOT', 'HKCR'
    }
    
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $safeKeyName = $keyName -replace '[^a-zA-Z0-9_]', '_'
    
    # Place backup in the same directory as script
    $scriptDir = Split-Path $PSCommandPath -Parent
    if ([string]::IsNullOrEmpty($scriptDir)) { $scriptDir = $PSScriptRoot }
    if ([string]::IsNullOrEmpty($scriptDir)) { $scriptDir = $pwd }
    $backupFile = Join-Path $scriptDir "backup_${safeKeyName}_${timestamp}.reg"
    
    # Execute built-in reg export
    & reg.exe export "$regPath" "$backupFile" /y | Out-Null
    return $backupFile
}

function Get-ContextMenuItems {
    $items = @()
    
    # Registry targets
    $paths = @(
        @{ Hive = "HKCU"; Path = "Software\Classes\*\shell"; Scope = "User"; Type = "File" },
        @{ Hive = "HKCU"; Path = "Software\Classes\Directory\shell"; Scope = "User"; Type = "Folder" },
        @{ Hive = "HKCU"; Path = "Software\Classes\Directory\Background\shell"; Scope = "User"; Type = "Background" }
    )
    
    # If admin, we can query and delete HKCR (system wide). 
    # If not admin, we can still query HKCR, but mark it as ReadOnly since standard users cannot modify it.
    if ($IsAdmin) {
        $paths += @(
            @{ Hive = "HKCR"; Path = "*\shell"; Scope = "Global"; Type = "File" },
            @{ Hive = "HKCR"; Path = "Directory\shell"; Scope = "Global"; Type = "Folder" },
            @{ Hive = "HKCR"; Path = "Directory\Background\shell"; Scope = "Global"; Type = "Background" }
        )
    } else {
        $paths += @(
            @{ Hive = "HKCR"; Path = "*\shell"; Scope = "Global (ReadOnly)"; Type = "File" },
            @{ Hive = "HKCR"; Path = "Directory\shell"; Scope = "Global (ReadOnly)"; Type = "Folder" },
            @{ Hive = "HKCR"; Path = "Directory\Background\shell"; Scope = "Global (ReadOnly)"; Type = "Background" }
        )
    }

    foreach ($p in $paths) {
        $regPath = ""
        if ($p.Hive -eq "HKCU") {
            $regPath = "Registry::HKEY_CURRENT_USER\" + $p.Path
        } else {
            $regPath = "Registry::HKEY_CLASSES_ROOT\" + $p.Path
        }
        
        if (Test-Path -LiteralPath $regPath) {
            $subKeys = Get-ChildItem -LiteralPath $regPath -ErrorAction SilentlyContinue
            foreach ($key in $subKeys) {
                # Skip core Windows system defaults
                $keyName = $key.PSChildName
                if ($keyName -in @("AnyCode", "explore", "open", "find", "cmd", "Powershell", "runas")) {
                    continue
                }
                
                # Extract descriptive label
                $displayName = ""
                try {
                    $displayName = (Get-ItemProperty -LiteralPath $key.PSPath -Name "(Default)" -ErrorAction SilentlyContinue)."(Default)"
                } catch {}
                if ([string]::IsNullOrEmpty($displayName)) {
                    $displayName = $keyName
                }
                
                # Fetch targeting command
                $commandPath = Join-Path $key.PSPath "command"
                $commandValue = ""
                if (Test-Path -LiteralPath $commandPath) {
                    try {
                        $commandValue = (Get-ItemProperty -LiteralPath $commandPath -Name "(Default)" -ErrorAction SilentlyContinue)."(Default)"
                    } catch {}
                }
                
                # Retrieve custom Icon path if any
                $iconValue = ""
                try {
                    $iconValue = (Get-ItemProperty -LiteralPath $key.PSPath -Name "Icon" -ErrorAction SilentlyContinue)."Icon"
                } catch {}
                
                # Check for executable command content to filter out empty windows items
                if ([string]::IsNullOrEmpty($commandValue)) {
                    continue
                }
                
                $items += [PSCustomObject]@{
                    KeyName      = $keyName
                    DisplayName  = $displayName
                    Command      = $commandValue
                    Icon         = $iconValue
                    Scope        = $p.Scope
                    Type         = $p.Type
                    Path         = $key.PSPath
                    Hive         = $p.Hive
                    RelativePath = $p.Path + "\" + $keyName
                }
            }
        }
    }
    return $items
}

# ----------------- DYNAMIC CARDS SCANNED LIST LOADING -----------------
$script:currentFilter = "All"

function Load-ManageList {
    param ([string]$filter = $script:currentFilter)
    $script:currentFilter = $filter

    $ListContainer.Children.Clear()
    
    $items = Get-ContextMenuItems
    
    # Apply filter
    if ($filter -ne "All") {
        $items = $items | Where-Object { $_.Type -eq $filter }
    }
    
    # Update active filter button styles dynamically
    $BtnFilterAll.Style    = $window.Resources["FilterBtn"]
    $BtnFilterFile.Style   = $window.Resources["FilterBtn"]
    $BtnFilterFolder.Style = $window.Resources["FilterBtn"]
    $BtnFilterBg.Style     = $window.Resources["FilterBtn"]
    
    switch ($filter) {
        "All"        { $BtnFilterAll.Style    = $window.Resources["FilterBtnActive"] }
        "File"       { $BtnFilterFile.Style   = $window.Resources["FilterBtnActive"] }
        "Folder"     { $BtnFilterFolder.Style = $window.Resources["FilterBtnActive"] }
        "Background" { $BtnFilterBg.Style     = $window.Resources["FilterBtnActive"] }
    }
    
    if ($items.Count -eq 0) {
        $noItemText = [System.Windows.Controls.TextBlock]::new()
        $noItemText.Text = "暂无检测到的自定义右键菜单项"
        $noItemText.Foreground = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(160, 160, 165))
        $noItemText.FontSize = 13
        $noItemText.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
        $noItemText.Margin = [System.Windows.Thickness]::new(0, 60, 0, 0)
        $ListContainer.Children.Add($noItemText) | Out-Null
        return
    }
    
    foreach ($item in $items) {
        # Card container Border
        $card = [System.Windows.Controls.Border]::new()
        $card.Background = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(33, 33, 38))
        $card.BorderBrush = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(46, 46, 53))
        $card.BorderThickness = [System.Windows.Thickness]::new(1)
        $card.CornerRadius = [System.Windows.CornerRadius]::new(6)
        $card.Margin = [System.Windows.Thickness]::new(0, 0, 0, 10)
        $card.Padding = [System.Windows.Thickness]::new(12)
        
        $grid = [System.Windows.Controls.Grid]::new()
        $col0 = [System.Windows.Controls.ColumnDefinition]::new()
        $col0.Width = [System.Windows.GridLength]::new(1, [System.Windows.GridUnitType]::Star)
        $col1 = [System.Windows.Controls.ColumnDefinition]::new()
        $col1.Width = [System.Windows.GridLength]::Auto
        $grid.ColumnDefinitions.Add($col0)
        $grid.ColumnDefinitions.Add($col1)
        
        $leftPanel = [System.Windows.Controls.StackPanel]::new()
        
        # Row 1: Icon Emojis & Display Name
        $row1 = [System.Windows.Controls.StackPanel]::new()
        $row1.Orientation = [System.Windows.Controls.Orientation]::Horizontal
        
        $emoji = "📄"
        if ($item.Type -eq "Folder") { $emoji = "📁" }
        elseif ($item.Type -eq "Background") { $emoji = "🖥️" }
        
        $emojiBlock = [System.Windows.Controls.TextBlock]::new()
        $emojiBlock.Text = $emoji
        $emojiBlock.FontSize = 13
        $emojiBlock.Margin = [System.Windows.Thickness]::new(0, 0, 8, 0)
        $emojiBlock.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
        $row1.Children.Add($emojiBlock) | Out-Null
        
        $titleBlock = [System.Windows.Controls.TextBlock]::new()
        $titleBlock.Text = $item.DisplayName
        $titleBlock.Foreground = [System.Windows.Media.Brushes]::White
        $titleBlock.FontSize = 13
        $titleBlock.FontWeight = [System.Windows.FontWeights]::Bold
        $titleBlock.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
        $row1.Children.Add($titleBlock) | Out-Null
        
        # Category Tag (User / Global / Readonly)
        $tagBorder = [System.Windows.Controls.Border]::new()
        $tagBorder.CornerRadius = [System.Windows.CornerRadius]::new(4)
        $tagBorder.Padding = [System.Windows.Thickness]::new(6, 2, 6, 2)
        $tagBorder.Margin = [System.Windows.Thickness]::new(10, 0, 0, 0)
        $tagBorder.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
        
        $tagText = [System.Windows.Controls.TextBlock]::new()
        $tagText.FontSize = 9
        $tagText.FontWeight = [System.Windows.FontWeights]::SemiBold
        
        if ($item.Scope -eq "User") {
            $tagBorder.Background = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(40, 58, 42))
            $tagText.Text = "当前用户"
            $tagText.Foreground = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(129, 199, 132))
        } elseif ($item.Scope -eq "Global") {
            $tagBorder.Background = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(58, 48, 38))
            $tagText.Text = "全局"
            $tagText.Foreground = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(255, 183, 77))
        } else {
            $tagBorder.Background = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(58, 38, 38))
            $tagText.Text = "全局 (只读 - 需管理员)"
            $tagText.Foreground = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(229, 57, 53))
        }
        
        $tagBorder.Child = $tagText
        $row1.Children.Add($tagBorder) | Out-Null
        
        # Position Tag (File / Folder / Background)
        $posBorder = [System.Windows.Controls.Border]::new()
        $posBorder.CornerRadius = [System.Windows.CornerRadius]::new(4)
        $posBorder.Padding = [System.Windows.Thickness]::new(6, 2, 6, 2)
        $posBorder.Margin = [System.Windows.Thickness]::new(8, 0, 0, 0)
        $posBorder.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
        
        $posText = [System.Windows.Controls.TextBlock]::new()
        $posText.FontSize = 9
        $posText.FontWeight = [System.Windows.FontWeights]::SemiBold
        
        if ($item.Type -eq "File") {
            $posBorder.Background = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(30, 45, 60))
            $posText.Text = "文件"
            $posText.Foreground = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(100, 181, 246))
        } elseif ($item.Type -eq "Folder") {
            $posBorder.Background = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(55, 45, 25))
            $posText.Text = "文件夹"
            $posText.Foreground = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(255, 213, 79))
        } else {
            $posBorder.Background = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(45, 30, 55))
            $posText.Text = "空白处"
            $posText.Foreground = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(224, 64, 251))
        }
        
        $posBorder.Child = $posText
        $row1.Children.Add($posBorder) | Out-Null
        
        $leftPanel.Children.Add($row1) | Out-Null
        
        # Row 2: Target Path info
        $cmdBlock = [System.Windows.Controls.TextBlock]::new()
        $cmdBlock.Text = "命令: " + $item.Command
        $cmdBlock.Foreground = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(150, 150, 155))
        $cmdBlock.FontSize = 11
        $cmdBlock.Margin = [System.Windows.Thickness]::new(0, 6, 0, 0)
        $cmdBlock.TextWrapping = [System.Windows.TextWrapping]::Wrap
        $leftPanel.Children.Add($cmdBlock) | Out-Null
        
        # Row 3: Registry Path description
        $pathBlock = [System.Windows.Controls.TextBlock]::new()
        $pathBlock.Text = "路径: " + $item.RelativePath
        $pathBlock.Foreground = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(105, 105, 110))
        $pathBlock.FontSize = 10
        $pathBlock.Margin = [System.Windows.Thickness]::new(0, 4, 0, 0)
        $pathBlock.TextWrapping = [System.Windows.TextWrapping]::Wrap
        $leftPanel.Children.Add($pathBlock) | Out-Null
        
        [System.Windows.Controls.Grid]::SetColumn($leftPanel, 0)
        $grid.Children.Add($leftPanel) | Out-Null
        
        # Delete Button (Right alignment)
        $btnDel = [System.Windows.Controls.Button]::new()
        $btnDel.Content = "删除"
        $btnDel.Tag = $item
        $btnDel.Width = 60
        $btnDel.Height = 28
        $btnDel.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
        $btnDel.Cursor = [System.Windows.Input.Cursors]::Hand
        
        if ($item.Scope -eq "Global (ReadOnly)") {
            $btnDel.IsEnabled = $false
            $btnDel.Opacity = 0.4
            $btnDel.ToolTip = "管理全局菜单项目需要管理员运行此工具"
        }
        
        # Red warning flat design button template
        $delTemplateXml = @"
<ControlTemplate xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" TargetType="Button">
    <Border x:Name="b" Background="#E53935" CornerRadius="4">
        <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" TextBlock.Foreground="White" TextBlock.FontWeight="Bold" TextBlock.FontSize="11"/>
    </Border>
    <ControlTemplate.Triggers>
        <Trigger Property="IsMouseOver" Value="True">
            <Setter TargetName="b" Property="Background" Value="#EF5350"/>
        </Trigger>
        <Trigger Property="IsPressed" Value="True">
            <Setter TargetName="b" Property="Background" Value="#C62828"/>
        </Trigger>
    </ControlTemplate.Triggers>
</ControlTemplate>
"@
        $delReader = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new($delTemplateXml))
        $btnDel.Template = [Windows.Markup.XamlReader]::Load($delReader)
        
        $btnDel.Add_Click({
            $currentItem = $this.Tag
            Add-Type -AssemblyName System.Windows.Forms
            $confirm = [System.Windows.Forms.MessageBox]::Show(
                "确定要删除右键菜单项【$($currentItem.DisplayName)】吗？`n这会立即从系统注册表中移除它，并且会在工具同级目录下自动导出备份 .reg 文件。",
                "确认删除右键菜单项",
                [System.Windows.Forms.MessageBoxButtons]::YesNo,
                [System.Windows.Forms.MessageBoxIcon]::Warning
            )
            
            if ($confirm -eq [System.Windows.Forms.DialogResult]::Yes) {
                try {
                    # 1. Export backup first
                    $backupFile = Backup-RegistryKey -psPath $currentItem.Path -keyName $currentItem.KeyName
                    
                    # 2. Delete registry path
                    Remove-Item -LiteralPath $currentItem.Path -Recurse -Force -ErrorAction Stop
                    
                    [System.Windows.Forms.MessageBox]::Show(
                        "删除成功！`n`n已在同级目录下生成备份文件：`n$(Split-Path $backupFile -Leaf)`n`n若需还原，直接双击该备份文件即可导入还原。",
                        "操作成功",
                        [System.Windows.Forms.MessageBoxButtons]::OK,
                        [System.Windows.Forms.MessageBoxIcon]::Information
                    )
                    
                    # Reload Dynamic view
                    Load-ManageList
                } catch {
                    [System.Windows.Forms.MessageBox]::Show(
                        "删除失败！错误信息：`n$($_.Exception.Message)",
                        "发生错误",
                        [System.Windows.Forms.MessageBoxButtons]::OK,
                        [System.Windows.Forms.MessageBoxIcon]::Error
                    )
                }
            }
        })
        
        [System.Windows.Controls.Grid]::SetColumn($btnDel, 1)
        $grid.Children.Add($btnDel) | Out-Null
        
        $card.Child = $grid
        $ListContainer.Children.Add($card) | Out-Null
    }
}

# ----------------- UI ELEMENT INTERACTION EVENT HANDLERS -----------------

# Sidebar Switch Panel Tab function
function Switch-Tab {
    param ([string]$tabName)
    
    $PanelAdd.Visibility      = [System.Windows.Visibility]::Collapsed
    $PanelManage.Visibility   = [System.Windows.Visibility]::Collapsed
    $PanelAbout.Visibility    = [System.Windows.Visibility]::Collapsed
    
    $NavBtnAdd.Style    = $window.Resources["SidebarBtn"]
    $NavBtnManage.Style = $window.Resources["SidebarBtn"]
    $NavBtnAbout.Style  = $window.Resources["SidebarBtn"]
    
    switch ($tabName) {
        "Add" {
            $PanelAdd.Visibility = [System.Windows.Visibility]::Visible
            $NavBtnAdd.Style = $window.Resources["SidebarBtnActive"]
        }
        "Manage" {
            $PanelManage.Visibility = [System.Windows.Visibility]::Visible
            $NavBtnManage.Style = $window.Resources["SidebarBtnActive"]
            Load-ManageList
        }
        "About" {
            $PanelAbout.Visibility = [System.Windows.Visibility]::Visible
            $NavBtnAbout.Style = $window.Resources["SidebarBtnActive"]
        }
    }
}

$NavBtnAdd.Add_Click({ Switch-Tab "Add" })
$NavBtnManage.Add_Click({ Switch-Tab "Manage" })
$NavBtnAbout.Add_Click({ Switch-Tab "About" })

# Category Filter Buttons
$BtnFilterAll.Add_Click({ Load-ManageList "All" })
$BtnFilterFile.Add_Click({ Load-ManageList "File" })
$BtnFilterFolder.Add_Click({ Load-ManageList "Folder" })
$BtnFilterBg.Add_Click({ Load-ManageList "Background" })

# File Browser Pickers
function Get-FilePath {
    param (
        [string]$Filter = "可执行程序 (*.exe;*.bat;*.cmd)|*.exe;*.bat;*.cmd|所有文件 (*.*)|*.*",
        [string]$Title = "选择目标应用程序"
    )
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = [System.Windows.Forms.OpenFileDialog]::new()
    $dialog.Filter = $Filter
    $dialog.Title = $Title
    if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        return $dialog.FileName
    }
    return ""
}

$BtnBrowseApp.Add_Click({
    $path = Get-FilePath
    if ($path) {
        $TxtAppPath.Text = $path
        # Auto fill display name based on name of program
        if ([string]::IsNullOrEmpty($TxtMenuName.Text)) {
            $exeName = [System.IO.Path]::GetFileNameWithoutExtension($path)
            $TxtMenuName.Text = "用 $exeName 打开"
        }
    }
})

$BtnBrowseIcon.Add_Click({
    $path = Get-FilePath -Filter "图标文件 (*.ico;*.exe;*.png;*.dll)|*.ico;*.exe;*.png;*.dll|所有文件 (*.*)|*.*" -Title "选择图标文件"
    if ($path) {
        $TxtIconPath.Text = $path
    }
})

# ----------------- REGISTRY WRITING CREATION ENGINE -----------------
$BtnCreateMenu.Add_Click({
    $menuName = $TxtMenuName.Text.Trim()
    $appPath = $TxtAppPath.Text.Trim()
    $iconPath = $TxtIconPath.Text.Trim()
    
    if ([string]::IsNullOrEmpty($menuName)) {
        [System.Windows.Forms.MessageBox]::Show("请填写右键菜单中显示的名称！", "输入错误", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }
    
    if ([string]::IsNullOrEmpty($appPath) -or -not (Test-Path $appPath)) {
        [System.Windows.Forms.MessageBox]::Show("应用路径不能为空且必须是有效的本地文件！", "输入错误", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }
    
    if ($ChkTypeFile.IsChecked -ne $true -and $ChkTypeFolder.IsChecked -ne $true -and $ChkTypeBackground.IsChecked -ne $true) {
        [System.Windows.Forms.MessageBox]::Show("请至少勾选一个菜单生效位置！", "输入错误", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }
    
    try {
        # Determine Registry target scope
        $baseHive = "HKCU"
        if ($RdoScopeGlobal.IsChecked -eq $true) {
            $baseHive = "HKCR"
        }
        
        # Sanitize Key Name using standard alphanumeric filtering
        $sanitizedKeyName = $menuName -replace '[^a-zA-Z0-9_\u4e00-\u9fa5]', ''
        if ([string]::IsNullOrEmpty($sanitizedKeyName)) {
            $sanitizedKeyName = "CustomItem_" + (Get-Random -Minimum 1000 -Maximum 9999)
        }
        
        # Build collection of target paths
        $pathsToWrite = @()
        if ($ChkTypeFile.IsChecked -eq $true) {
            $pathsToWrite += "$baseHive\Software\Classes\*\shell\$sanitizedKeyName"
        }
        if ($ChkTypeFolder.IsChecked -eq $true) {
            $pathsToWrite += "$baseHive\Software\Classes\Directory\shell\$sanitizedKeyName"
        }
        if ($ChkTypeBackground.IsChecked -eq $true) {
            $pathsToWrite += "$baseHive\Software\Classes\Directory\Background\shell\$sanitizedKeyName"
        }
        
        foreach ($path in $pathsToWrite) {
            $psPath = ""
            if ($path -match "^HKCU") {
                $psPath = "Registry::HKEY_CURRENT_USER\" + ($path -replace "^HKCU\\", "")
            } else {
                $psPath = "Registry::HKEY_CLASSES_ROOT\" + ($path -replace "^HKCR\\", "")
            }
            
            # Ensure key container is fully created
            New-Item -LiteralPath $psPath -Force | Out-Null
            
            # Add Menu Title Value
            Set-ItemProperty -LiteralPath $psPath -Name "(Default)" -Value $menuName -Force | Out-Null
            
            # Icon setup
            $finalIcon = $iconPath
            if ([string]::IsNullOrEmpty($finalIcon)) {
                $finalIcon = $appPath # default to target application
            }
            if (-not [string]::IsNullOrEmpty($finalIcon)) {
                Set-ItemProperty -LiteralPath $psPath -Name "Icon" -Value $finalIcon -Force | Out-Null
            }
            
            # Subkey named command
            $cmdPath = Join-Path $psPath "command"
            New-Item -LiteralPath $cmdPath -Force | Out-Null
            
            # Assign execution arguments based on shell context
            $cmdString = ""
            if ($path -match "Background") {
                $cmdString = "`"$appPath`" `"%V`""
            } else {
                $cmdString = "`"$appPath`" `"%1`""
            }
            Set-ItemProperty -LiteralPath $cmdPath -Name "(Default)" -Value $cmdString -Force | Out-Null
        }
        
        # Display smooth fade feedback
        $TxtAddFeedback.Text = "右键菜单项【$menuName】已成功添加！"
        $TxtAddFeedback.Foreground = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Color]::FromRgb(129, 199, 132))
        $TxtAddFeedback.Visibility = [System.Windows.Visibility]::Visible
        
        # Reset form fields
        $TxtMenuName.Text = ""
        $TxtAppPath.Text = ""
        $TxtIconPath.Text = ""
        $ChkTypeFile.IsChecked = $true
        $ChkTypeFolder.IsChecked = $true
        $ChkTypeBackground.IsChecked = $false
        
        # Non-blocking async delay to close feedback
        [System.Threading.Tasks.Task]::Delay(3500).ContinueWith({
            $window.Dispatcher.Invoke({
                $TxtAddFeedback.Visibility = [System.Windows.Visibility]::Collapsed
            })
        }) | Out-Null
        
    } catch {
        [System.Windows.Forms.MessageBox]::Show("写入注册表时发生错误！`n请确认您是否具有写入该位置的权限。`n错误详情：$($_.Exception.Message)", "写入失败", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

# Initialize and show WPF Application
$window.ShowDialog() | Out-Null
