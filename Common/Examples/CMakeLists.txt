include_directories( ${ACVD_SOURCE_DIR}/Common )

set(COMMON_EXAMPLES
  clipMesh
  viewer
  viewer2
  RandomTriangulation
  ExamplevtkSurface
  CleanMesh
  icp
  mesh2vtk
  meshComponents
  meshDifference
  vtk2ply
  stl2ply
  CheckOrientation
)

foreach(loop_var ${COMMON_EXAMPLES})
  add_executable(${loop_var} ${loop_var}.cxx)
  target_link_libraries(${loop_var} vtkSurface ${VTK_LIBRARIES})
endforeach(loop_var)

install( TARGETS ${COMMON_EXAMPLES}
  EXPORT ACVDTargets
  RUNTIME DESTINATION ${INSTALL_BIN_DIR}
  LIBRARY DESTINATION ${INSTALL_LIB_DIR}
  ARCHIVE DESTINATION ${INSTALL_LIB_DIR}
)

