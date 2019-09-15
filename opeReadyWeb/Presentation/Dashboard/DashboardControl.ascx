<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DashboardControl.ascx.cs"
    Inherits="PQ.Admin.Presentation.Dashboard.DashboardControl" %>
<asp:Chart ID="_mChart" runat="server" Height="400px" Width="460px" Palette="BrightPastel" >
    <Titles>
        <asp:Title ShadowColor="32, 0, 0, 0" Font="Trebuchet MS, 14.25pt, style=Bold" ShadowOffset="3"
            Alignment="MiddleLeft" ForeColor="26, 59, 105"
            Name="Title1">
        </asp:Title>
        <asp:Title ShadowColor="32, 0, 0, 0" Font="Trebuchet MS, 8pt, style=Bold" ShadowOffset="3"
            Alignment="MiddleLeft" ForeColor="26, 59, 105" Name="Title2">
        </asp:Title>
    </Titles>
    <Legends>
        <asp:Legend TitleFont="Trebuchet MS, 9pt, style=Bold" BackColor="Transparent"
            Font="Trebuchet MS, 8pt, style=Bold" Enabled="True"
            DockedToChartArea="ChartArea1" IsDockedInsideChartArea="False" Docking="Top"
            Name="Default" LegendItemOrder="SameAsSeriesOrder" ShadowOffset="0" 
            TitleAlignment="Far">
        </asp:Legend>
    </Legends>
    <Series>
        <asp:Series ChartArea="ChartArea1" BorderWidth="1" IsVisibleInLegend="False"
            ShadowOffset="3" Name="Default" Font="Trebuchet MS, 10pt, style=Bold" IsValueShownAsLabel="True" >
        </asp:Series>
    </Series>
    <ChartAreas>
        <asp:ChartArea Name="ChartArea1" BackColor="Transparent">
            <AxisX IsLabelAutoFit="False" Interval="1" IntervalAutoMode="VariableCount">
                <LabelStyle Font="Trebuchet MS, 10pt, style=Bold"  Interval="1"/>
                <MajorGrid LineWidth="0"></MajorGrid>
            </AxisX>
            <AxisY IsLabelAutoFit="True" Minimum="0" MaximumAutoSize="100">
                <LabelStyle Font="Trebuchet MS, 9.75pt" />
                <MajorGrid LineWidth="0"></MajorGrid>
            </AxisY>
        </asp:ChartArea>
    </ChartAreas>
</asp:Chart>



