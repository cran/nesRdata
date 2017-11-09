#' cache_path
#'
#' Return path to OS agnostic cache location specified by the rappdirs package
#'
#' @export
cache_path <- function() paste0(rappdirs::user_data_dir(
  appname   = "NES",
  appauthor = "NES"), .Platform$file.sep)

temp_path <- function() tempdir()

get_if_not_exists <- function(id, target, versioned_path){
  if(all(!file.exists(unlist(target)))){
    cn <- dataone::CNode("PROD")
    mn <- dataone::getMNode(cn, "urn:node:KNB")

    dt <- dataone::getPackage(mn, paste0("resourceMap_", id))
    td <- tempdir()
    unzip(dt, exdir = td)
    unzip(list.files(td,
                     recursive = TRUE, pattern = "NES",
                     include.dirs = TRUE, full.names = TRUE),
          exdir = versioned_path)
  }else{
    message(paste0("A local copy of the NES data already exists at one of: ",
                   paste(unlist(target, use.names = FALSE), collapse = " ")))
  }
}

stop_if_not_exists <- function(src_path) {
  if(!file.exists(src_path)){
    stop(paste0("Dataset not found at: ", src_path,
          "\n Try running the appropriate `get*` and/or `compile` commands."))
  }
}

get_version_list <- function(...){
  list.files(cache_path(), pattern = ".rds$", ...)
}