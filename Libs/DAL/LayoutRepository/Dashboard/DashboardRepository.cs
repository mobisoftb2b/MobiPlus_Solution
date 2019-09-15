using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MobiPlus.Models.AgentDailyTasks;
using MobiPlus.Models.Common;
using MobiPlus.Models.Dashboard;
using MobiPlusTools;
using MobiPlus.Models.GridDefinition;
using DAL.Common;
using MobiPlus.Models.Hardware;

namespace DAL.LayoutRepository.Dashboard
{
    public class DashboardRepository : BaseRepository, IRepository<DashboardModel, FilterParams>
    {
        #region IDisposable Support
        private bool _disposedValue = false;

        protected virtual void Dispose(bool disposing)
        {
            if (!_disposedValue)
            {
                if (disposing)
                {
                    // TODO: dispose managed state (managed objects).
                }

                _disposedValue = true;
            }
        }

        public void Dispose()
        {
            Dispose(true);
        }



        #endregion

        public Task<DashboardModel> GetDataByID(FilterParams param)
        {
            throw new NotImplementedException();
        }

        public Task<IEnumerable<DashboardModel>> GetFilteredData(FilterParams param)
        {
            throw new NotImplementedException();
        }

        public async Task<List<GridSettings>> Layout_GetReportColsAsync(FilterParams grid)
        {
            return await Task.Run(() => Layout_GetReportCols(grid));
        }
        private List<GridSettings> Layout_GetReportCols(FilterParams grid)
        {
            var result = new List<GridSettings>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_GetReportColsData(grid.ReportID, grid.LanguageID)
                        .Select(a => new GridSettings
                        {
                            Alignment = a.Alignment,
                            ColCaption = a.ColCaption,
                            ColIsSummary = a.ColIsSummary,
                            ColMaxLength = a.ColMaxLength,
                            ColName = a.ColName,
                            ColOrder = a.ColOrder,
                            ColWidth = a.ColWidthWeight,
                            FormatID = a.FormatID,
                            ReportColID = a.ReportColID,
                            ReportName = a.ReportName,
                            Style = context.MPLayout_GetReportStyles(a.StyleID, grid.VersionID ?? 0).Select(s => new GridStyle
                            {
                                BackColor = s.BackColor,
                                FontFamily = s.FontFamily,
                                FontSize = s.FontSize,
                                ForeColor = s.ForeColor,
                                isBold = Convert.ToBoolean(s.isBold),
                                isBlink = Convert.ToBoolean(s.isBlink),
                                isUnderline = Convert.ToBoolean(s.isUnderline),
                                StyleID = s.StyleID,
                                StyleName = s.StyleName
                            }).FirstOrDefault()
                        }).ToList();
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;

        }



        public async Task<List<CustDailyTasks>> Layout_GetReportDataAsync(FilterParams grid)
        {
            return await Task.Run(() => Layout_GetReportData(grid));
        }
        private List<CustDailyTasks> Layout_GetReportData(FilterParams grid)
        {

            var result = new List<CustDailyTasks>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_POD_WEB_ConcentrationActivityAllCountries(grid.CountryID, grid.DistrID, grid.AgentID, grid.FromDate, grid.ToDate)
                        .Select(a => new CustDailyTasks
                        {
                            AgentId = a.AgentId1,
                            AgentReturn = a.AgentReturn,
                            DriverName = a.DriverName,
                            DriverReturn = a.DriverReturn,
                            DriverStatus = a.DriverStatus,
                            NotFullDelivery = a.NotFullDelivery,
                            NotVisited = a.NotVisited,
                            Orders = a.Delivery,
                            Shipment = a.Shipment,
                            Status = a.DriverStatus,
                            ImgStatus = a.imgStatus,
                            Mission = a.Mission,
                            Progress = a.Progress,
                            Cycle = a.Cycle,
                            Visit = a.Visit,
                            Delivery = a.Delivery,
                            LongDistance = a.LongDistance,
                            EndSupplyDate = a.EndSupplyDate,
                            CountryID = string.IsNullOrEmpty(a.CountryID1) ? null : (long?)long.Parse(a.CountryID1),
                            DistrID = string.IsNullOrEmpty(a.DistrID1) ? null : (long?)long.Parse(a.DistrID1),
                            FromDate = a.FromDate1,
                            TaskDate = a.TaskDate
                        }).ToList();
                }
            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;

        }
        public async Task<IEnumerable<CustomerModel>> Layout_POD_WEB_AgentDailyActivityAsync(FilterParams inParams)
        {
            return await Task.Run(() => Layout_POD_WEB_AgentDailyActivity(inParams));
        }

        private List<CustomerModel> Layout_POD_WEB_AgentDailyActivity(FilterParams grid)
        {
            var result = new List<CustomerModel>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_POD_WEB_AgentDailyActivity(grid.CountryID.ToString(), grid.DistrID.ToString(), grid.AgentID.ToString(), grid.FromDate, grid.ToDate)
                        .Select(a => new CustomerModel
                        {
                            DriverID = a.AgentId1,
                            DriverReturn = a.DriverReturn,
                            Shipment = a.Shipment,
                            CustomerAddress = a.CustAddress,
                            Driver = a.Driver,
                            Customer = a.Cust,
                            CustomerID = a.CustId1,
                            TravelHours = a.TravelHours,
                            ServiceHours = a.ServiceHours,
                            OriginalTime = a.OriginalTime,
                            DeliveryTime = a.DeliveryTime,
                            DistrID = a.DistrID1,
                            TaskDate = a.TaskDate,
                            ImgStatus = a.imgStatus,
                            STYLE_CollectedSurfaces = a.STYLE_CollectedSurfaces,
                            STYLE_DriverReturn = a.STYLE_DriverReturn,
                            STYLE_ServiceHours = a.STYLE_ServiceHours,
                            Delivery = a.Delivery,
                            CustReturn = a.CustReturns,
                            CollectedSurfaces = a.CollectedSurfaces,
                            ReportGPS_Lat = a.ReportGPS_Lat,
                            ReportGPS_Lon = a.ReportGPS_Lon,
                            Mission = a.Mission,
                            Quality = a.Quality
                        }).ToList();
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;
        }




        public async Task<IEnumerable<CustomerModel>> Layout_POD_WEB_AgentDailyActivity_PopUpAsync(FilterParams inParams)
        {
            return await Task.Run(() => Layout_POD_WEB_AgentDailyActivity_PopUp(inParams));
        }
        private List<CustomerModel> Layout_POD_WEB_AgentDailyActivity_PopUp(FilterParams inParams)
        {
            var result = new List<CustomerModel>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_POD_WEB_AgentDailyActivity_PopUp(inParams.CountryID.ToString(), inParams.DistrID.ToString(), inParams.AgentID.ToString(),
                        inParams.FromDate, inParams.CustomerID)
                        .Select(a => new CustomerModel
                        {
                            Shipment = a.Shipment,
                            CustomerAddress = a.CustAddress,
                            Driver = a.Driver,
                            Customer = a.Cust,
                            ImgStatus = a.imgStatus,
                            TaskDescription = a.TaskDescription,
                            DeliveryNum = a.DeliveryNum,
                            Comment = a.Comment,
                            Description = a.Description
                        }).ToList();
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;
        }

        public async Task<List<CustDailyTasks>> Layout_GetNestedDataAsync(FilterParams inParams)
        {
            return await Task.Run(() => Layout_GetNestedData(inParams));
        }

        private List<CustDailyTasks> Layout_GetNestedData(FilterParams grid)
        {

            var result = new List<CustDailyTasks>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_POD_WEB_ConcentrationActivity_PopUp(grid.CountryID.ToString(), grid.DistrID.ToString(), grid.AgentID.ToString(), grid.FromDate, grid.ToDate, grid.Cycle.ToString())
                        .Select(a => new CustDailyTasks
                        {
                            AgentId = int.Parse(a.AgentId),
                            DriverReturn = a.DriverReturn,
                            Shipment = int.Parse(a.Shipment),
                            Address = a.CustAddress,
                            DriverName = a.Driver,
                            CustomerDesc = a.Cust,
                            TravelHours = a.TravelHours,
                            ServiceHours = a.ServiceHours,
                            OriginalTime = a.OriginalTime,
                            DeliveryTime = a.DeliveryTime,
                            Status = a.LastStatus,
                            ImgStatus = a.imgStatus,
                            ActualSortOrder = a.ActualSortOrder,
                            Cycle = a.Cycle,
                            SortOrder = a.SortOrder,
                            Delivery = a.Delivery,
                            AgentReturn = a.CustReturns,
                            CollectedSurfaces = a.CollectedSurfaces,
                            DriverStatus = a.LastStatus
                        }).ToList();
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;

        }

        public async Task<IEnumerable<DriverStatusModel>> Layout_POD_WEB_DriverStatusAllAsync(FilterParams inParams)
        {
            return await Task.Run(() => Layout_POD_WEB_DriverStatusAll(inParams));
        }

        private IEnumerable<DriverStatusModel> Layout_POD_WEB_DriverStatusAll(FilterParams inParams)
        {
            var result = new List<DriverStatusModel>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_POD_WEB_DriverStatusAll(inParams.CountryID.ToString(), inParams.DistrID.ToString(), inParams.AgentID.ToString(), inParams.FromDate, inParams.ToDate)
                        .Select(a => new DriverStatusModel
                        {
                            DriverID = a.DriverID,
                            DriverName = a.DriverName,
                            Cycle = a.Cycle.ToString(),
                            imgLineDownload = a.imgLineDownload,
                            imgWise = a.imgWise,
                            STYLE_imgLineDownload = a.STYLE_imgLineDownload,
                            STYLE_imgWise = a.STYLE_imgWise,
                            imgLineEnded = a.imgLineEnded,
                            STYLE_imgLineEnded = a.STYLE_imgLineEnded,
                            imgArriveBB = a.imgArriveBB,
                            STYLE_imgArriveBB = a.STYLE_imgArriveBB,
                            imgLeaveBB = a.imgLeaveBB,
                            STYLE_imgLeaveBB = a.STYLE_imgLeaveBB,
                            UpdateDate = a.UpdateDate,
                            imgToDiplomat = a.imgToDiplomat
                        }).ToList();
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;
        }

        public async Task<List<DriverStatusModel>> Layout_DriverStatusPopUpAsync(FilterParams inParams)
        {
            return await Task.Run(() => Layout_DriverStatusPopUp(inParams));
        }

        private List<DriverStatusModel> Layout_DriverStatusPopUp(FilterParams grid)
        {

            var result = new List<DriverStatusModel>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_POD_WEB_DriverStatus_PopUp(grid.CountryID.ToString(), grid.DistrID.ToString(), grid.AgentID.ToString(), grid.FromDate, grid.ToDate)
                        .Select(a => new DriverStatusModel
                        {
                            TaskTime = a.TaskTime,
                            ShipmentID = a.ShipmentID,
                            Customer = a.Cust,
                            CustAddress = a.CustAddress,
                            TaskID = a.TaskID,
                            DocNumber = a.DocNum,
                            ReportCode = a.ReportCode,
                            Description = a.Description,
                            Comment = a.Comment,
                            LastChange = a.LastChange
                        }).ToList();
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;

        }


        #region Maps
        public async Task<IEnumerable<DriverModel>> MPLayout_GetDriverGPSLocationByCountryAsync(FilterParams param)
        {
            return await Task.Run(() => MPLayout_GetDriverGPSLocationByCountry(param));
        }

        private IEnumerable<DriverModel> MPLayout_GetDriverGPSLocationByCountry(FilterParams param)
        {

            var result = new List<DriverModel>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_GetDriverGPSLocation(param.AgentID, param.FromDate, param.CountryID, param.ToDate)
                        .Select(a => new DriverModel
                        {
                            DriverID = long.Parse(a.AgentID),
                            DriverName = a.Name,
                            DriverGPSLocation = new GPSLocation
                            {
                                Comment = a.Comment,
                                Lat = a.Lat,
                                Lng = a.Lon,
                                LocationID = a.DriverGPSLocationID
                            }
                        }).ToList();
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;

        }

        public async Task<IEnumerable<Customer>> MPLayout_GetCustomersCordAsync(FilterParams param)
        {
            return await Task.Run(() => MPLayout_GetCustomersCord(param));
        }
        private IEnumerable<Customer> MPLayout_GetCustomersCord(FilterParams param)
        {

            var result = new List<Customer>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_CustomersCordSelect(param.AgentID, param.FromDate, param.CountryID, param.DistrID, param.ToDate)
                        .Select(a => new Customer
                        {
                            CustomerID = a.CustID,
                            CustomerName = a.CustName,
                            Address = a.Address,
                            Color = a.Color,
                            IsNotSupplayAndVisit = a.IsNotSupplayAndVisit,
                            IsVisit = a.IsVisit == 0 ? false : true,
                            Location = new GPSLocation
                            {
                                Comment = a.Comment,
                                Lat = a.Lat,
                                Lng = a.Lon,
                                ReportGPS_LAT = a.ReportGPS_LAT,
                                ReportGPS_Lng = a.ReportGPS_Lon
                            }
                        }).ToList();
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;

        }

        public async Task<IEnumerable<Customer>> Layout_GetCustomersRoadCordAsync(FilterParams param)
        {
            return await Task.Run(() => Layout_GetCustomersRoadCord(param));
        }
        private IEnumerable<Customer> Layout_GetCustomersRoadCord(FilterParams param)
        {

            var result = new List<Customer>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_CustomersRoadCordSelect(param.AgentID, long.Parse(param.FromDate), param.CountryID, param.ToDate)
                        .Select(a => new Customer
                        {
                            AgentId = a.AgentCode,
                            Color = a.Color,
                            Location = new GPSLocation
                            {
                                LocationID = a.DriverGPSLocationID,
                                Lat = a.Lat,
                                Lng = a.Lon,
                            }
                        }).ToList();
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;

        }
        #endregion

        #region End of Day
        public async Task<List<EndDayModel>> Layout_POD_WEB_EndDay_SelectAsync(FilterParams inParams)
        {
            return await Task.Run(() => Layout_POD_WEB_EndDay_Select(inParams));
        }

        private List<EndDayModel> Layout_POD_WEB_EndDay_Select(FilterParams param)
        {

            var result = new List<EndDayModel>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_POD_WEB_EndDay_Select(param.CountryID, param.DistrID, param.AgentID, param.FromDate, param.ToDate)
                        .Select(a => new EndDayModel
                        {
                            ImgStatus = a.imgStatus,
                            CountryID = a.CountryID,
                            FromDate = a.FromDate,
                            DriverID = a.DriverID.ToString(),
                            DriverName = a.DriverName,
                            Shipment = a.Shipment.ToString(),
                            Delivery = a.Delivery,
                            AgentReturn = a.AgentReturn,
                            DriverReturn = a.DriverReturn,
                            CollectedSurfaces = a.CollectedSurfaces.ToString(),
                            STYLE_CollectedSurfaces = a.STYLE_CollectedSurfaces,
                            DistansePlanned = a.KmPlanned,
                            DistanseReal = a.KmActual
                        }).ToList();
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;

        }

        public async Task<List<EndDayModel>> Layout_POD_WEB_EndDayDetails_SelectAsync(FilterParams inParams)
        {
            return await Task.Run(() => Layout_POD_WEB_EndDayDetails_Select(inParams));
        }

        private List<EndDayModel> Layout_POD_WEB_EndDayDetails_Select(FilterParams param)
        {

            var result = new List<EndDayModel>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_POD_WEB_EndDayDetails_Select(param.CountryID, param.DistrID, param.AgentID, param.FromDate, param.ToDate)
                        .Select(a => new EndDayModel
                        {
                            ImgStatus = a.imgStatus,
                            DriverName = a.Driver,
                            Shipment = a.Shipment,
                            Delivery = a.Delivery,
                            AgentReturn = a.CustReturns,
                            DriverReturn = a.DriverReturn,
                            CollectedSurfaces = a.CollectedSurfaces.ToString(),
                            STYLE_CollectedSurfaces = a.STYLE_CollectedSurfaces,
                            CustomerAddress = a.CustAddress,
                            Customer = a.Cust,
                            Status = a.LastStatus,
                            Order = a.SortOrder
                        }).ToList();
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;

        }
        #endregion

        #region Notes Collection
        public async Task<IEnumerable<NotesCollectionModel>> Layout_POD_WEB_NotesCollectionAsync(FilterParams param)
        {
            return await Task.Run(() => Layout_POD_WEB_NotesCollection(param));
        }
        private IEnumerable<NotesCollectionModel> Layout_POD_WEB_NotesCollection(FilterParams param)
        {

            var result = new List<NotesCollectionModel>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_POD_WEB_NotesCollection(param.CountryID, param.DistrID, param.AgentID, param.FromDate, param.ToDate)
                        .Select(a => new NotesCollectionModel
                        {
                            AgentID = a.AgentID,
                            Customer = a.Customer,
                            CustomerComment = a.CustComment,
                            DeliveryNum = a.DeliveryNum,
                            DeliveryStatus = a.DeliveryStatus,
                            DriverName = a.DriverName,
                            InvoiceComment = a.InvoiceComment,
                            TaskDescription = a.TaskDescription
                        }).ToList();
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;

        }
        #endregion

        #region Driver Reports

        public async Task<IEnumerable<DriverReports>> Layout_POD_WEB_AgentsReportAsync(FilterParams param)
        {
            return await Task.Run(() => Layout_POD_WEB_AgentsReport(param));
        }
        private IEnumerable<DriverReports> Layout_POD_WEB_AgentsReport(FilterParams param)
        {

            var result = new List<DriverReports>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_POD_WEB_AgentsReport(param.CountryID, param.DistrID, param.AgentID, param.FromDate, param.ToDate)
                        .Select(a => new DriverReports
                        {
                            DriverName = a.Agent,
                            Customer = a.Customer,
                            DocStartTime = a.DocStartTime,
                            Item = a.Item,
                            QTY = a.QTY,
                            ReasonDescription = a.ReasonDescription,
                            Reference = a.Reference,
                            ShipmentNumber = a.ShipmentNumber
                        }).ToList();
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;

        }


        public async Task<IEnumerable<DriverReportsNT>> Layout_POD_WEB_AgentsReportNoTargetAsync(FilterParams param)
        {
            return await Task.Run(() => Layout_POD_WEB_AgentsReportNoTarget(param));
        }
        private IEnumerable<DriverReportsNT> Layout_POD_WEB_AgentsReportNoTarget(FilterParams param)
        {

            var result = new List<DriverReportsNT>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_POD_WEB_AgentsReportNoTarget(param.CountryID, param.DistrID, param.AgentID, param.FromDate, param.ToDate)
                        .Select(a => new DriverReportsNT
                        {
                            Customer = a.Customer,
                            Delivery = a.Delivery,
                            DriverName = a.Driver,
                            ReportDescription = a.ReportDescription,
                            ShipmentID = a.ShipmentID
                        }).ToList();
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;

        }
        #endregion


    }


}
