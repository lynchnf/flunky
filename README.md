# Flunky

Source code generator

## To Do List
- [x] different date types: date, time, timestamp
  - [x] write data in FakeDataUtil
  - [x] data/time/datetime picker
  - [x] change label on date/time edit labels (M/d/yyyy => m/d/y, h:m a => h:m am/pm
- [x] enums
  - [x] generate
  - [x] edit dropdowns
- [ ] exclude stuff
  - [x] exclude fields from list, view, edit
  - [ ] exclude entity list/add from menu
  - [ ] conditional generation of files
- [ ] unit tests
- [ ] validation of files
- [x] separate jar files
  - [x] GenerationBean, ProjectType interface, TemplateType in one jar
  - [x] ProjectType implementation and template resources in second jar
  - [x] ApplicationBean, Main, LoggingException in third bean 
- [ ] bat and shell files to run from command line
- [ ] documentation!
  - [ ] project docs
  - [ ] runtime module docs
