{
  format = "[](#9A348E)$os$username[](bg:#DA627D fg:#9A348E)$directory[](fg:#DA627D bg:#FCA17D)$git_branch$git_status[](fg:#FCA17D bg:#86BBD8)$c$elixir$elm$golang$gradle$haskell$java$julia$nodejs$nim$rust$scala[](fg:#86BBD8 bg:#06969A)$docker_context[](fg:#06969A bg:#33658A)$time[ ](fg:#33658A)";
  c = {
    format = "[ $symbol ($version) ]($style)";
    style = "bg:#86BBD8";
    symbol = " ";
  };
  directory = {
    format = "[ $path ]($style)";
    style = "bg:#DA627D";
    truncation_length = 3;
    truncation_symbol = "…/";
    substitutions = {
      Documents = "󰈙 ";
      Downloads = " ";
      Music = " ";
      Pictures = " ";
    };
  };
  docker_context = {
    format = "[ $symbol $context ]($style)";
    style = "bg:#06969A";
    symbol = " ";
  };
  elixir = {
    format = "[ $symbol ($version) ]($style)";
    style = "bg:#86BBD8";
    symbol = " ";
  };
  elm = {
    format = "[ $symbol ($version) ]($style)";
    style = "bg:#86BBD8";
    symbol = " ";
  };
  git_branch = {
    format = "[ $symbol $branch ]($style)";
    style = "bg:#FCA17D";
    symbol = "";
  };
  git_status = {
    format = "[$all_status$ahead_behind ]($style)";
    style = "bg:#FCA17D";
  };
  golang = {
    format = "[ $symbol ($version) ]($style)";
    style = "bg:#86BBD8";
    symbol = " ";
  };
  gradle = {
    format = "[ $symbol ($version) ]($style)";
    style = "bg:#86BBD8";
  };
  haskell = {
    format = "[ $symbol ($version) ]($style)";
    style = "bg:#86BBD8";
    symbol = " ";
  };
  java = {
    format = "[ $symbol ($version) ]($style)";
    style = "bg:#86BBD8";
    symbol = " ";
  };
  julia = {
    format = "[ $symbol ($version) ]($style)";
    style = "bg:#86BBD8";
    symbol = " ";
  };
  nim = {
    format = "[ $symbol ($version) ]($style)";
    style = "bg:#86BBD8";
    symbol = "󰆥 ";
  };
  nodejs = {
    format = "[ $symbol ($version) ]($style)";
    style = "bg:#86BBD8";
    symbol = "";
  };
  os = {
    disabled = true;
    style = "bg:#9A348E";
  };
  rust = {
    format = "[ $symbol ($version) ]($style)";
    style = "bg:#86BBD8";
    symbol = "";
  };
  scala = {
    format = "[ $symbol ($version) ]($style)";
    style = "bg:#86BBD8";
    symbol = " ";
  };
  time = {
    disabled = false;
    format = "[ ♥ $time ]($style)";
    style = "bg:#33658A";
    time_format = "%R";
  };
  username = {
    disabled = false;
    format = "[$user ]($style)";
    show_always = true;
    style_root = "bg:#9A348E";
    style_user = "bg:#9A348E";
  };
}
