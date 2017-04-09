hpdf = require("hpdf")

mm = function(mm)
    return mm * (72.0 / 25.4)
end

inch = function(inch)
    return inch * 72.0
end

Document = {}

function Document:New()
    local o = {
        _inst = hpdf.New()
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function Document:SetCompressionMode(mode)
    local modes = {
        all = hpdf.COMP_ALL,
        none = hpdf.COMP_NONE,
        text = hpdf.COMP_TEXT,
        image = hpdf.COMP_IMAGE,
        metadata = hpdf.COMP_METADATA,
        all = hpdf.COMP_ALL,
        mask = hpdf.COMP_MASK,
    }
    hpdf.SetCompressionMode(self._inst, modes[mode])
end

function Document:UseUTFEncodings()
    hpdf.UseUTFEncodings(self._inst)
end

function Document:GetFont(name, encoding)
    return hpdf.GetFont(self._inst, name, encoding)
end

function Document:LoadTTFontFromFile(filename, embed, encoding)
    local name = hpdf.LoadTTFontFromFile(self._inst, filename, embed)
    return self:GetFont(name, encoding)
end

function Document:Save(filename)
    hpdf.SaveToFile(self._inst, filename)
end

function Document:AddPage()
    return Page:New(self)
end

Page = {}

function Page:New(doc)
    local o = {
        _inst = hpdf.AddPage(doc._inst),
        default_line_width = mm(0.2),
        margin = mm(10)
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function Page:SetSize(size, ori)
    local sizes = {
        A4 = "HPDF_PAGE_SIZE_A4",
    }
    local orientations = {
        portrait = "HPDF_PAGE_PORTRAIT",
        landscape = "HPDF_PAGE_LANDSCAPE",
    }
    hpdf.Page_SetSize(self._inst, sizes[size], orientations[ori])
end

function Page:BeginText()
    hpdf.Page_BeginText(self._inst)
end

function Page:EndText()
    hpdf.Page_EndText(self._inst)
end

function Page:TextRect(left, top, right, bottom, text, align)
    local aligns = {
        left = "HPDF_TALIGN_LEFT",
        right = "HPDF_TALIGN_RIGHT",
        center = "HPDF_TALIGN_CENTER",
        justify = "HPDF_TALIGN_JUSTIFY",
    }
    hpdf.Page_TextRect(self._inst, left, top, right, bottom, text,
        aligns[align])
end

function Page:SetFontAndSize(font, size)
    hpdf.Page_SetFontAndSize(self._inst, font, size)
end

function Page:SetLineWidth(width)
    hpdf.Page_SetLineWidth(self._inst, width)
end

function Page:MoveTo(x, y)
    hpdf.Page_MoveTo(self._inst, x, y)
end

function Page:LineTo(x, y)
    hpdf.Page_LineTo(self._inst, x, y)
end

function Page:Stroke()
    hpdf.Page_Stroke(self._inst)
end

function Page:Line(x1, y1, x2, y2, width)
    width = width or self.default_line_width
    self:SetLineWidth(width)
    self:MoveTo(x1, y1)
    self:LineTo(x2, y2)
    self:Stroke()
end

function Page:GetWidth()
    return hpdf.Page_GetWidth(self._inst)
end

function Page:GetHeight()
    return hpdf.Page_GetHeight(self._inst)
end

function Page:GetContentWidth()
    return self:GetWidth() - self.margin * 2
end

function Page:GetContentHeight()
    return self:GetHeight() - self.margin * 2
end

function Page:SetMargin(margin)
    self.margin = margin
end

function Page:GetMargin()
    return self.margin
end

function Page:CreateGrid(columns, rows)
    self.columns = columns
    self.column_width = self:GetContentWidth() / columns

    self.rows = rows
    self.row_height = self:GetContentHeight() / rows
end

function Page:DrawGrid()
    local left = self:GetMargin()
    local top = self:GetHeight() - self:GetMargin()
    local right = self:GetWidth() - self:GetMargin()
    local bottom = self:GetMargin()

    for col = 0, self.columns do
        local x = left + col * self.column_width
        self:Line(x, top, x, bottom)
    end

    for row = 0, self.rows do
        local y = top - row * self.row_height
        self:Line(left, y, right, y)
    end
end

function Page:TextCell(column, row, colspan, rowspan, text, align)
    local left = self:GetMargin() + column * self.column_width
    local top = self:GetHeight() - self:GetMargin() - row * self.row_height
    local right = left + colspan * self.column_width
    local bottom = top - rowspan * self.row_height
    self:TextRect(left, top, right, bottom, text, align)
end
