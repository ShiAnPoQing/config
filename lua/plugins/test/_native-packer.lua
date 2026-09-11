return {
  name = "_native-packer",
  config = function()
    require("native-packer.core").add({
      {
        "user1/plugin1",
        priority = 100,
      },
      {
        "user2/plugin2",
        priority = 200,
      },
      {
        "user3/plugin3",
        priority = 300,
        depend = {
          "user1/plugin1",
          "user2/plugin2",
        },
      },
      {
        "user4/plugin4",
        priority = 400,
      },
    })
  end,
}
