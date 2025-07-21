local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("cs", {
  s("for", {
    t("for (int "), i(1, "i"), t(" = 0; "), rep(1), t(" < "), i(2, "length"), t("; "), rep(1), t("++) {"), t({"", "    "}),
    i(0), t({"", "}"})
  })
})
