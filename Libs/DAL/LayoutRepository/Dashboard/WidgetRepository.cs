using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CodeFirstStoredProcs;
using DAL.Common;
using MobiPlus.Models.Common.FilterModel;
using MobiPlus.Models.Dashboard;

namespace DAL.LayoutRepository.Dashboard
{
    public class WidgetRepository : BaseRepository, IFilterRepository<WidgetModel, WidgetParams>
    {
        public async Task<IEnumerable<WidgetModel>> GetDataByID(WidgetParams param)
        {
            return await Task.Run(() => Layout_Widgets_Select(param));
        }

        /// <summary>
        /// Select of widget data 
        /// </summary>
        /// <param name="param"></param>
        /// <returns></returns>
        public IEnumerable<WidgetModel> Layout_Widgets_Select(WidgetParams param)
        {
            var result = new List<WidgetModel>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    var sqlparam = param.Report_SP_Params.Replace(";", ",").TrimEnd(',');
                    var sqlquery = $"exec {param.ReportQuery} {sqlparam}";

                    var CountryID = new SqlParameter
                    {
                        ParameterName = "@CountryID",
                        SqlDbType = SqlDbType.NVarChar,
                        IsNullable = true,
                        SqlValue = param.CountryID ?? (object)DBNull.Value
                    };
                    var DistrID = new SqlParameter
                    {
                        ParameterName = "@DistrID",
                        SqlDbType = SqlDbType.NVarChar,
                        IsNullable = true,
                        SqlValue = param.DistrID ?? (object)DBNull.Value
                    };
                    var AgentId = new SqlParameter
                    {
                        ParameterName = "@AgentId",
                        SqlDbType = SqlDbType.NVarChar,
                        IsNullable = true,
                        SqlValue = param.AgentId ?? (object)DBNull.Value
                    };
                    var FromDate = new SqlParameter
                    {
                        ParameterName = "@FromDate",
                        SqlDbType = SqlDbType.NVarChar,
                        IsNullable = true,
                        SqlValue = param.FromDate ?? (object)DBNull.Value
                    };
                    var ToDate = new SqlParameter
                    {
                        ParameterName = "@ToDate",
                        SqlDbType = SqlDbType.NVarChar,
                        IsNullable = true,
                        SqlValue = param.FromDate ?? (object)DBNull.Value
                    };

                    var temp = context.Database.SqlQuery<WidgetModel>(sqlquery, CountryID, DistrID,
                        AgentId, FromDate).ToList<WidgetModel>();

                    foreach (var model in temp)
                    {
                        result.Add(new WidgetModel
                        {
                            ChartColor = model.ChartColor,
                            Done = model.Done,
                            IconName = model.IconName,
                            LowerText = model.LowerText,
                            BGColor = model.BGColor,
                            Percent = model.Percent,
                            Plan = model.Plan,
                            SubBgColor = model.SubBgColor,
                            Title = model.Title,
                            UpperText = model.UpperText,
                            WidgetID = model.WidgetID,
                            Value = model.Value,
                            Color = model.Color
                        });
                    }
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;
        }

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


        public async Task<WidgetModel> POD_Widget_SelectAsync(WidgetParams inParams)
        {
            return await Task.Run(() => POD_Widget_Select(inParams));
        }

        private WidgetModel POD_Widget_Select(WidgetParams inParams)
        {
            var result = new WidgetModel();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_POD_Widget_Customers(inParams.CountryID, inParams.DistrID, inParams.AgentId,
                            inParams.FromDate, inParams.ToDate, inParams.LanguageID)
                        .Select(a => new WidgetModel
                        {
                            ChartColor = a.ChartColor,
                            Done = a.Done,
                            IconName = a.IconName,
                            BGColor = a.BGColor,
                            Percent = a.Percent,
                            Plan = a.Plan,
                            SubBgColor = a.SubBgColor,
                            Title = a.Title,
                            TrackColor = a.TrackColor,
                            Color = a.Color,
                            PlanDone = string.Format("{0} | {1}", a.Done, a.Plan)
                        }).FirstOrDefault();
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;

        }

        public async Task<WidgetModel> Layout_POD_Widget_NotFullDeliveryAsync(FilterParams inParams)
        {
            return await Task.Run(() => Layout_POD_Widget_NotFullDelivery(inParams));
        }

        private WidgetModel Layout_POD_Widget_NotFullDelivery(FilterParams inParams)
        {
            var result = new WidgetModel();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_POD_Widget_NotFullDelivery(inParams.CountryID, inParams.DistrID, inParams.AgentID,
                            inParams.FromDate, inParams.ToDate, inParams.LanguageID)
                        .Select(a => new WidgetModel
                        {
                            IconName = a.IconName,
                            BGColor = a.BGColor,
                            SubBgColor = a.SubBgColor,
                            Title = a.Title,
                            UpperText = a.VALUE,
                            Color = a.Color
                        }).FirstOrDefault();
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;

        }

        public async Task<WidgetModel> Layout_POD_Widget_DeliveryAsync(FilterParams inParams)
        {
            return await Task.Run(() => Layout_POD_Widget_Delivery(inParams));
        }

        private WidgetModel Layout_POD_Widget_Delivery(FilterParams inParams)
        {
            var result = new WidgetModel();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_POD_Widget_Delivery(inParams.CountryID, inParams.DistrID, inParams.AgentID,
                            inParams.FromDate, inParams.ToDate, inParams.LanguageID)
                        .Select(a => new WidgetModel
                        {
                            ChartColor = a.ChartColor,
                            Done = a.Done,
                            IconName = a.IconName,
                            BGColor = a.BGColor,
                            Percent = int.Parse(a.Percent),
                            Plan = a.Plan,
                            SubBgColor = a.SubBgColor,
                            Title = a.Title,
                            TrackColor = a.TrackColor,
                            Color = a.Color,
                            PlanDone = string.Format("{0} | {1}", a.Done, a.Plan)
                        }).FirstOrDefault();
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;

        }

        public async Task<WidgetModel> Layout_POD_Widget_AgentReturnAsync(FilterParams inParams)
        {
            return await Task.Run(() => Layout_POD_Widget_AgentReturn(inParams));
        }

        private WidgetModel Layout_POD_Widget_AgentReturn(FilterParams inParams)
        {
            var result = new WidgetModel();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_POD_Widget_AgentReturn(inParams.CountryID, inParams.DistrID, inParams.AgentID,
                            inParams.FromDate, inParams.ToDate, inParams.LanguageID)
                        .Select(a => new WidgetModel
                        {
                            ChartColor = a.ChartColor,
                            Done = a.Done,
                            IconName = a.IconName,
                            BGColor = a.BGColor,
                            Percent = int.Parse(a.Percent),
                            Plan = a.Plan,
                            SubBgColor = a.SubBgColor,
                            Title = a.Title,
                            TrackColor = a.TrackColor,
                            Color = a.Color,
                            PlanDone = string.Format("{0} | {1}", a.Done, a.Plan)
                        }).FirstOrDefault();
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;

        }

        public async Task<WidgetModel> Layout_POD_Widget_TasksAsync(FilterParams inParams)
        {
            return await Task.Run(() => Layout_POD_Widget_Tasks(inParams));
        }

        private WidgetModel Layout_POD_Widget_Tasks(FilterParams inParams)
        {
            var result = new WidgetModel();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_POD_Widget_Tasks(inParams.CountryID, inParams.DistrID, inParams.AgentID,
                            inParams.FromDate, inParams.ToDate, inParams.LanguageID)
                        .Select(a => new WidgetModel
                        {
                            ChartColor = a.ChartColor,
                            Done = int.Parse(a.Done),
                            IconName = a.IconName,
                            BGColor = a.BGColor,
                            Percent = a.Percent,
                            Plan = int.Parse(a.Plan),
                            SubBgColor = a.SubBgColor,
                            Title = a.Title,
                            TrackColor = a.TrackColor,
                            Color = a.Color,
                            PlanDone = string.Format("{0} | {1}", a.Done, a.Plan)
                        }).FirstOrDefault();
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;

        }

        public async Task<WidgetModel> Layout_POD_Widget_NonVisitAsync(FilterParams inParams)
        {
            return await Task.Run(() => Layout_POD_Widget_NonVisit(inParams));
        }

        private WidgetModel Layout_POD_Widget_NonVisit(FilterParams inParams)
        {
            var result = new WidgetModel();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_POD_Widget_NotVisit(inParams.CountryID.ToString(), inParams.DistrID.ToString(), inParams.AgentID.ToString(),
                            inParams.FromDate, inParams.ToDate, inParams.LanguageID)
                        .Select(a => new WidgetModel
                        {
                            IconName = a.IconName,
                            BGColor = a.BGColor,
                            SubBgColor = a.SubBgColor,
                            Title = a.Title,
                            UpperText = a.Value,
                            Color = a.Color
                        }).FirstOrDefault();
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;

        }
    }
}
