using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for PagedList
/// </summary>
public class PagedList
{
    IEnumerable _rows;
    int _totalRecords;
    int _pageIndex;
    int _pageSize;
    object _userData;

    public PagedList(IEnumerable rows, int totalRecords, int pageIndex, int pageSize, object userData)
    {
        _rows = rows;
        _totalRecords = totalRecords;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
        _userData = userData;
    }

    public PagedList(IEnumerable rows, int totalRecords, int pageIndex, int pageSize)
        : this(rows, totalRecords, pageIndex, pageSize, null)
    {
    }

    public int total
    {
        get
        {
            return (int)Math.Ceiling((decimal)_totalRecords / (decimal)_pageSize);
        }
    }

    public int page { get { return _pageIndex; } }

    public int records { get { return _totalRecords; } }

    public IEnumerable rows { get { return _rows; } }

    public object userData { get { return _userData; } }
}