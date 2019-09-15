using DAL.Common;
using MobiPlus.Models.Common.FilterModel;
using MobiPlus.Models.Dashboard;
using MobiPlus.Models.Layout;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Runtime.Remoting.Contexts;
using System.Text;
using System.Threading.Tasks;
using CodeFirstStoredProcs;

namespace DAL.LayoutRepository.Layout
{
    public class LayoutRepository : BaseRepository, IFilterRepository<LayoutModel, FilterParams>
    {

        public async Task<IEnumerable<LayoutModel>> GetDataByID(FilterParams param)
        {
            return await Task.Run(() => Layout_Reports2Form_SelectAll(param));
        }
        private IEnumerable<LayoutModel> Layout_Reports2Form_SelectAll(FilterParams param)
        {
            var result = new List<LayoutModel>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_Reports2Form_SelectAll(param.FormID, param.TabID, param.ReportID)
                        .Select(a => new LayoutModel
                        {
                            ContentDimension_X = a.ContentDim_Width,
                            ContentDimension_Y = a.ContentDim_Height,
                            ContentDim_MaxHeight = a.ContentDim_MaxHeight,
                            ContentDim_MaxWidth = a.ContentDim_MaxWidth,
                            ContentDim_MinHeight = a.ContentDim_MinHeight,
                            ContentDim_MinWidth = a.ContentDim_MinWidth,
                            IsStatic = a.IsStatic,
                            isResizable = a.isResizable,
                            isDraggable = a.isDraggable,
                            IsVisible = a.IsVisible,
                            Report = new ReportModel
                            {
                                ReportID = a.ReportID,
                                ReportName = a.ReportName,
                                ReportTypeID = a.ReportTypeID,
                                ReportQuery = a.ReportQuery,
                                ReportCaption = a.ReportCaption,
                                ReportTemplate = a.Layout_ReportTemplate_Desc,
                                Report_SP_Params = a.Report_SP_Params
                            },
                            StartPos_X = a.StartPos_X,
                            StartPos_Y = a.StartPos_Y,
                            Tabs = new TabModel { TabID = a.TabID, TabDescription = a.TabName },
                            Forms = new FormModel { FormID = a.FormID, FormName = a.FormName }
                        }).ToList();
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;

        }
        public async Task<IEnumerable<FormModel>> Layout_MenuItems_SelectByUserAsync(FilterParams param)
        {
            return await Task.Run(() => Layout_MenuItems_SelectByUser(param));
        }
        private IEnumerable<FormModel> Layout_MenuItems_SelectByUser(FilterParams param)
        {
            var result = new List<FormModel>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_MenuItems_SelectByUser(param.UserID, param.LanguageID)
                        .Select(a => new FormModel
                        {
                            FormID = a.FormID,
                            FormName = a.Description,
                            CssIcon = a.CssIcon,
                            RoutePath = a.RoutePath,
                            ParentFormID = a.MenuItemParentID
                        }).ToList();
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;

        }


        public async Task<IEnumerable<TabModel>> Layout_TabsItems_SelectByUserAsync(FilterParams filterParams)
        {
            return await Task.Run(() => Layout_TabsItems_SelectByUser(filterParams));
        }

        private IEnumerable<TabModel> Layout_TabsItems_SelectByUser(FilterParams filterParams)
        {
            var result = new List<TabModel>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_TabsItems_SelectByUser(filterParams.FormID, filterParams.TabID, filterParams.UserID,filterParams.LanguageID)
                        .Select(a => new TabModel
                        {
                            TabDescription = a.TabName,
                            TabID = a.TabID,
                            FormID = a.FormID,
                            Layouts = context.Layout_Reports2Form_SelectAll(a.FormID, a.TabID, filterParams.ReportID)
                                .Select(s => new LayoutModel
                                {
                                    ContentDimension_X = s.ContentDim_Width,
                                    ContentDimension_Y = s.ContentDim_Height,
                                    ContentDim_MaxHeight = s.ContentDim_MaxHeight,
                                    ContentDim_MaxWidth = s.ContentDim_MaxWidth,
                                    ContentDim_MinHeight = s.ContentDim_MinHeight,
                                    ContentDim_MinWidth = s.ContentDim_MinWidth,
                                    IsStatic = s.IsStatic,
                                    isResizable = s.isResizable,
                                    isDraggable = s.isDraggable,
                                    IsVisible = s.IsVisible,
                                    Report = new ReportModel
                                    {
                                        ReportID = s.ReportID,
                                        ReportName = s.ReportName,
                                        ReportTypeID = s.ReportTypeID,
                                        ReportQuery = s.ReportQuery,
                                        ReportCaption = s.ReportCaption,
                                        ReportTemplate = s.Layout_ReportTemplate_Desc,
                                        ReportDataSourceID = s.ReportDataSourceID,
                                        Report_SP_Params = s.Report_SP_Params,
                                        Widgets = s.ReportDataSourceID == 3 ? context.Database.SqlQuery<WidgetModel>($"exec {s.ReportQuery} {s.Report_SP_Params.Replace(";", ",").TrimEnd(',')}",
                                        new SqlParameter(Check(() => filterParams.CountryID), filterParams.CountryID),
                                                new SqlParameter(Check(() => filterParams.DistrID), filterParams.DistrID),
                                                new SqlParameter(Check(() => filterParams.AgentID), filterParams.AgentID),
                                                new SqlParameter(Check(() => filterParams.FromDate), filterParams.FromDate)).Select(
                                            model => new WidgetModel
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
                                                Color = model.Color,
                                                TrackColor = model.TrackColor
                                            }).FirstOrDefault<WidgetModel>() : null
                                    },
                                    StartPos_X = s.StartPos_X,
                                    StartPos_Y = s.StartPos_Y,
                                    Tabs = new TabModel { TabID = s.TabID, TabDescription = s.TabName },
                                    Forms = new FormModel { FormID = s.FormID, FormName = s.FormName }
                                }).ToList()
                        }).ToList();
                }
            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;
        }

        static string Check<T>(Expression<Func<T>> expr)
        {
            var body = ((MemberExpression)expr.Body);
            return body.Member.Name;
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

    }


}
