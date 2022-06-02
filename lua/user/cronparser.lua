local cronparser = {}


local numberTokens = {
  ["0"] = 0, ["1"] = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9,
  ["00"] = 0, ["01"] = 1, ["02"] = 2, ["03"] = 3, ["04"] = 4, ["05"] = 5, ["06"] = 6, ["07"] = 7, ["08"] = 8, ["09"] = 9,
  ["10"] = 10, ["11"] = 11, ["12"] = 12, ["13"] = 13, ["14"] = 14, ["15"] = 15, ["16"] = 16, ["17"] = 17, ["18"] = 18, ["19"] = 19,
  ["20"] = 20, ["21"] = 21, ["22"] = 22, ["23"] = 23, ["24"] = 24, ["25"] = 25, ["26"] = 26, ["27"] = 27, ["28"] = 28, ["29"] = 29,
  ["30"] = 30, ["31"] = 31, ["32"] = 32, ["33"] = 33, ["34"] = 34, ["35"] = 35, ["36"] = 36, ["37"] = 37, ["38"] = 38, ["39"] = 39,
  ["40"] = 40, ["41"] = 41, ["42"] = 42, ["43"] = 43, ["44"] = 44, ["45"] = 45, ["46"] = 46, ["47"] = 47, ["48"] = 48, ["49"] = 49,
  ["50"] = 50, ["51"] = 51, ["52"] = 52, ["53"] = 53, ["54"] = 54, ["55"] = 55, ["56"] = 56, ["57"] = 57, ["58"] = 58, ["59"] = 59,
  ["1970"] = 1970, ["1971"] = 1971, ["1972"] = 1972, ["1973"] = 1973, ["1974"] = 1974, ["1975"] = 1975, ["1976"] = 1976, ["1977"] = 1977, ["1978"] = 1978, ["1979"] = 1979,
  ["1980"] = 1980, ["1981"] = 1981, ["1982"] = 1982, ["1983"] = 1983, ["1984"] = 1984, ["1985"] = 1985, ["1986"] = 1986, ["1987"] = 1987, ["1988"] = 1988, ["1989"] = 1989,
  ["1990"] = 1990, ["1991"] = 1991, ["1992"] = 1992, ["1993"] = 1993, ["1994"] = 1994, ["1995"] = 1995, ["1996"] = 1996, ["1997"] = 1997, ["1998"] = 1998, ["1999"] = 1999,
  ["2000"] = 2000, ["2001"] = 2001, ["2002"] = 2002, ["2003"] = 2003, ["2004"] = 2004, ["2005"] = 2005, ["2006"] = 2006, ["2007"] = 2007, ["2008"] = 2008, ["2009"] = 2009,
  ["2010"] = 2010, ["2011"] = 2011, ["2012"] = 2012, ["2013"] = 2013, ["2014"] = 2014, ["2015"] = 2015, ["2016"] = 2016, ["2017"] = 2017, ["2018"] = 2018, ["2019"] = 2019,
  ["2020"] = 2020, ["2021"] = 2021, ["2022"] = 2022, ["2023"] = 2023, ["2024"] = 2024, ["2025"] = 2025, ["2026"] = 2026, ["2027"] = 2027, ["2028"] = 2028, ["2029"] = 2029,
  ["2030"] = 2030, ["2031"] = 2031, ["2032"] = 2032, ["2033"] = 2033, ["2034"] = 2034, ["2035"] = 2035, ["2036"] = 2036, ["2037"] = 2037, ["2038"] = 2038, ["2039"] = 2039,
  ["2040"] = 2040, ["2041"] = 2041, ["2042"] = 2042, ["2043"] = 2043, ["2044"] = 2044, ["2045"] = 2045, ["2046"] = 2046, ["2047"] = 2047, ["2048"] = 2048, ["2049"] = 2049,
  ["2050"] = 2050, ["2051"] = 2051, ["2052"] = 2052, ["2053"] = 2053, ["2054"] = 2054, ["2055"] = 2055, ["2056"] = 2056, ["2057"] = 2057, ["2058"] = 2058, ["2059"] = 2059,
  ["2060"] = 2060, ["2061"] = 2061, ["2062"] = 2062, ["2063"] = 2063, ["2064"] = 2064, ["2065"] = 2065, ["2066"] = 2066, ["2067"] = 2067, ["2068"] = 2068, ["2069"] = 2069,
  ["2070"] = 2070, ["2071"] = 2071, ["2072"] = 2072, ["2073"] = 2073, ["2074"] = 2074, ["2075"] = 2075, ["2076"] = 2076, ["2077"] = 2077, ["2078"] = 2078, ["2079"] = 2079,
  ["2080"] = 2080, ["2081"] = 2081, ["2082"] = 2082, ["2083"] = 2083, ["2084"] = 2084, ["2085"] = 2085, ["2086"] = 2086, ["2087"] = 2087, ["2088"] = 2088, ["2089"] = 2089,
  ["2090"] = 2090, ["2091"] = 2091, ["2092"] = 2092, ["2093"] = 2093, ["2094"] = 2094, ["2095"] = 2095, ["2096"] = 2096, ["2097"] = 2097, ["2098"] = 2098, ["2099"] = 2099,
}

local monthTokens = {
  ["1"] = 1, ["jan"] = 1, ["january"] = 1,
  ["2"] = 2, ["feb"] = 2, ["february"] = 2,
  ["3"] = 3, ["mar"] = 3, ["march"] = 3,
  ["4"] = 4, ["apr"] = 4, ["april"] = 4,
  ["5"] = 5, ["may"] = 5,
  ["6"] = 6, ["jun"] = 6, ["june"] = 6,
  ["7"] = 7, ["jul"] = 7, ["july"] = 7,
  ["8"] = 8, ["aug"] = 8, ["august"] = 8,
  ["9"] = 9, ["sep"] = 9, ["september"] = 9,
  ["10"] = 10, ["oct"] = 10, ["october"] = 10,
  ["11"] = 11, ["nov"] = 11, ["november"] = 11,
  ["12"] = 12, ["dec"] = 12, ["december"] = 12,
}

local dowTokens = {
  ["0"] = 0, ["sun"] = 0, ["sunday"] = 0,
  ["1"] = 1, ["mon"] = 1, ["monday"] = 1,
  ["2"] = 2, ["tue"] = 2, ["tuesday"] = 2,
  ["3"] = 3, ["wed"] = 3, ["wednesday"] = 3,
  ["4"] = 4, ["thu"] = 4, ["thursday"] = 4,
  ["5"] = 5, ["fri"] = 5, ["friday"] = 5,
  ["6"] = 6, ["sat"] = 6, ["saturday"] = 6,
  ["7"] = 0,
}

-- gsplit: iterate over substrings in a string separated by a pattern
--
-- Parameters:
-- text (string)    - the string to iterate over
-- pattern (string) - the separator pattern
-- plain (boolean)  - if true (or truthy), pattern is interpreted as a plain
--                    string, not a Lua pattern
--
-- Returns: iterator
--
-- Usage:
-- for substr in gsplit(text, pattern, plain) do
--   doSomething(substr)
-- end
--
-- @see https://stackoverflow.com/a/43582076
local function gsplit(text, pattern, plain)
  local splitStart, length = 1, #text
  return function()
    if splitStart then
      local sepStart, sepEnd = string.find(text, pattern, splitStart, plain)
      local ret
      if not sepStart then
        ret = string.sub(text, splitStart)
        splitStart = nil
      elseif sepEnd < sepStart then
        -- Empty separator!
        ret = string.sub(text, splitStart, sepStart)
        if sepStart < length then
          splitStart = sepStart + 1
        else
          splitStart = nil
        end
      else
        ret = sepStart > splitStart and string.sub(text, splitStart, sepStart - 1) or ''
        splitStart = sepEnd + 1
      end
      return ret
    end
  end
end

-- split: split a string into substrings separated by a pattern.
--
-- Parameters:
-- text (string)    - the string to iterate over
-- pattern (string) - the separator pattern
-- plain (boolean)  - if true (or truthy), pattern is interpreted as a plain
--                    string, not a Lua pattern
--
-- Returns: table (a sequence table containing the substrings)
--
-- @see https://stackoverflow.com/a/43582076
local function split(text, pattern, plain)
  local ret = {}
  for match in gsplit(text, pattern, plain) do
    table.insert(ret, match)
  end
  return ret
end

cronparser.parse = function(expression)
  local list = split(expression, " ", true)
end

return cronparser
