# vtkSurface and vtkSurfaceBase Documentation

## Overview

`vtkSurface` and `vtkSurfaceBase` are core classes in the ACVD library that provide efficient data structures for 3D triangular mesh processing. These classes extend VTK's `vtkPolyData` to offer optimized functionality specifically designed for mesh manipulation, topological querying, and geometric analysis.

For detailed agentic guidelines and $O(1)$ mesh data structure mechanics, see [Master AGENTS.md](../AGENTS.md).

---

## 1. vtkSurfaceBase

`vtkSurfaceBase` is the foundational class that provides an efficient edge-oriented representation of triangular meshes. It extends `vtkPolyData` with specialized functionality for mesh operations that VTK's standard poly data structure lacks.

### Key Features
- **Edge-Oriented Representation**: Unlike traditional VTK poly data structures, `vtkSurfaceBase` provides true edge connectivity with constant-time access to adjacent vertices, faces, and edges.
- **Efficient Connectivity Queries**: Offers $O(1)$ access time for connectivity information, making it suitable for complex mesh processing algorithms.
- **Low-Level Mesh Operations**: Provides fundamental mesh manipulation operations like edge flipping, vertex merging, and face deletion.
- **Memory Management**: Includes garbage collection for deleted elements and efficient memory allocation strategies (`CleanMemory()`, `SQueeze()`).
- **Manifold Support**: Handles both manifold and non-manifold mesh topologies with proper validation (`IsEdgeManifold`).

---

### Core Functionality

#### Basic Mesh Operations

##### Vertex Management
- `AddVertex(double x, double y, double z)`: Add vertex with specified coordinates, returns vertex ID.
- `AddVertex(double *P)`: Add vertex with coordinates from array, returns vertex ID.
- `GetPointCoordinates(vtkIdType Point, double *x)`: Get coordinates of vertex $(x,y,z)$ into array.
- `SetPointCoordinates(vtkIdType Point, double *x)`: Set coordinates of vertex from array.

##### Edge Operations
- `AddEdge(const vtkIdType& v1, const vtkIdType& v2)`: Add edge between two vertices, returns edge ID.
- `FlipEdge(vtkIdType edge)`: Flip an edge, returns `-1` if successful, edge ID if already exists.
- `FlipEdgeSure(vtkIdType edge)`: Flip edge repeatedly until successful, returns `-1` if successful.
- `BisectEdge(vtkIdType e)`: Bisect edge by creating midpoint vertex and new faces, returns new vertex ID.
- `IsEdge(const vtkIdType &v1, const vtkIdType &v2)`: Check if edge exists between vertices, returns edge ID or `-1`.

##### Face Manipulation
- `AddFace(const vtkIdType& ve1, const vtkIdType& ve2, const vtkIdType& ve3)`: Add triangular face, returns face ID.
- `AddPolygon(int NumberOfVertices, vtkIdType* Vertices)`: Add polygon face, returns face ID.
- `DeleteFace(vtkIdType f1)`: Delete face and cleanup associated edges/vertices if unused.
- `ChangeFaceVertex(vtkIdType Face, vtkIdType OldVertex, vtkIdType NewVertex)`: Replace vertex in face.
- `IsFace(const vtkIdType &v1, const vtkIdType &v2, const vtkIdType &v3)`: Check if face exists, returns face ID or `-1`.

#### Connectivity Methods

##### Vertex Connectivity
- `GetVertexNeighbours(vtkIdType v1, vtkIdList *Output)`: Get list of adjacent vertices to vertex $v_1$.
- `GetVertexNeighbourEdges(vtkIdType v1, vtkIdList *Output)`: Get list of adjacent edges to vertex $v_1$.
- `GetVertexNeighbourEdges(const vtkIdType& v1, vtkIdType &NumberOfEdges, vtkIdType* &Edges)`: Get pointer to edges in vertex ring (faster).
- `GetVertexNeighbourFaces(const vtkIdType &v1, vtkIdList *Output)`: Get list of adjacent faces to vertex $v_1$.
- `GetValence(const vtkIdType& v1)`: Get number of adjacent edges (valence) of vertex $v_1$.
- `GetNumberOfBoundaries(const vtkIdType &v1)`: Get number of boundary edges incident to vertex $v_1$.

##### Edge Connectivity
- `GetEdgeVertices(const vtkIdType& edge, vtkIdType &v1, vtkIdType &v2)`: Get vertices bounding edge.
- `GetEdgeFaces(const vtkIdType& e1, vtkIdType &f1, vtkIdType &f2)`: Get faces adjacent to edge.
- `GetEdgeFaces(vtkIdType e1, vtkIdList *Flist)`: Get list of adjacent faces to edge.
- `IsEdgeManifold(const vtkIdType& e)`: Test if edge is manifold (has exactly 2 adjacent faces).
- `GetEdgeNumberOfAdjacentFaces(const vtkIdType &e)`: Get number of faces adjacent to edge.
- `IsEdgeBetweenFaces(const vtkIdType &f1, const vtkIdType &f2)`: Get edge ID between two faces, returns `-1` if none.

##### Face Connectivity
- `GetFaceVertices(const vtkIdType& face, vtkIdType &v1, vtkIdType &v2, vtkIdType &v3)`: Get vertices bounding face.
- `GetFaceVertices(const vtkIdType& face, vtkIdType &NumberOfVertices, vtkIdType* &Vertices)`: Get vertex list of face.
- `GetFaceNeighbours(vtkIdType Face, vtkIdList *FList)`: Get list of adjacent faces to face.
- `GetFaceNeighbours(vtkIdListCollection *FList)`: Get collection of adjacent faces.
- `GetThirdPoint(const vtkIdType& f1, const vtkIdType& v1, const vtkIdType& v2)`: Get third vertex of face given two vertices.

#### Topology Management
- `SetOrientationOn()`: Enable surface orientation checking.
- `SetOrientationOff()`: Disable surface orientation checking.
- `CheckNormals()`: Reorder cell descriptions for proper orientation.
- `MergeVertices(vtkIdType v1, vtkIdType v2)`: Combine two vertices (used for edge collapse operations).
- `DeleteFace(vtkIdType f1)`: Delete face and cleanup associated edges/vertices if unused.
- `DeleteEdge(vtkIdType e1)`: Delete edge and cleanup associated vertices if unused.
- `DeleteVertex(vtkIdType v1)`: Delete vertex if unused.
- `Conquer(const vtkIdType& f1, const vtkIdType& v1, const vtkIdType& v2, vtkIdType &f2, vtkIdType &v3)`: Traverse mesh through edge $(v_1,v_2)$.

---

## 2. vtkSurface

`vtkSurface` is a derived class that builds upon `vtkSurfaceBase` to provide higher-level utilities for mesh processing, format I/O, and analysis.

### Key Features
- **File I/O Operations**: Load and save meshes in various formats (`.ply`, `.vtk`, `.wrl`, `.stl`).
- **Mesh Analysis**: Compute geometric properties, areas, normals, and statistics.
- **Mesh Preprocessing**: Subdivision, noise addition, coordinate rescaling, and quantization.
- **Connectivity Analysis**: Identify connected components, sharp vertices, and mesh properties.
- **Quality Metrics**: Compute triangle quality, angles, and mesh statistics.

---

### Extended Functionality

#### Mesh Analysis & Properties

##### Geometric Measurements
- `GetTrianglesAreas()`: Compute areas of all triangles in the mesh, returns `vtkDoubleArray`.
- `GetFaceArea(vtkIdType Face)`: Compute area of specific face.
- `GetEdgeLengths()`: Compute lengths of all edges, returns `vtkDoubleArray`.
- `GetEdgeLength(vtkIdType Edge)`: Compute length of specific edge.
- `GetDistanceBetweenVertices(vtkIdType V1, vtkIdType V2)`: Compute Euclidean distance between vertices.

##### Mesh Statistics
- `ComputeTrianglesStatistics(double &Amin, double &Aav, double &Qmin, double &Qav, double &P30)`: Compute mesh quality metrics:
  - `Amin`: Minimum triangle angle
  - `Aav`: Average minimum triangle angle  
  - `Qmin`: Minimum triangle quality
  - `Qav`: Average triangle quality
  - `P30`: Percentage of triangles with quality $> 30^\circ$
- `ComputeQualityHistogram(const char *FileName)`: Compute triangle quality histogram to file.

##### Connectivity Analysis
- `GetConnectedComponents()`: Compute connected components, returns `vtkIdListCollection`.
- `GetBiggestConnectedComponent()`: Return mesh with largest connected component.
- `GetBiggestConnectedComponents(int numberOfComponents)`: Return mesh with $n$ largest components.
- `CleanConnectivity(double tolerance)`: Fix connectivity issues by merging close vertices.

##### Vertex Properties
- `GetVertexArea(vtkIdType Vertex)`: Calculate area associated with vertex.
- `GetVerticesAreas()`: Compute areas for all vertices, returns `vtkDoubleArray`.
- `GetVertexNormal(vtkIdType Vertex, double *Normal)`: Compute normal at vertex.
- `GetTriangleNormal(vtkIdType Triangle, double *Normal)`: Compute normal of triangle.

#### File Operations

##### Loading/Saving
- `CreateFromFile(const char *FileName)`: Load mesh from file (supports `.wrl`, `.vtk`, `.ply`, `.stl`).
- `WriteToFile(const char *FileName)`: Save mesh to file (supports `.vtk`, `.ply`).
- `WriteInventor(const char *filename)`: Export to `.iv` format.
- `WriteSMF(const char *filename)`: Export to `.smf` format.

##### Mesh Data Access
- `PrintVerticesCoordinates()`: Print all vertex coordinates to console.
- `PrintConnectivity()`: Print mesh connectivity to console.
- `SaveConnectivity(const char *FileName)`: Save mesh connectivity to file.

#### Mesh Processing

##### Subdivision
- `Subdivide(vtkIntArray *Parent1=0, vtkIntArray *Parent2=0)`: Return subdivided mesh.
- `SubdivideInPlace(vtkIntArray *Parent1=0, vtkIntArray *Parent2=0)`: Subdivide mesh in-place.

##### Preprocessing
- `SplitLongEdges(double Ratio)`: Split edges longer than $\text{Ratio} \times \text{AverageLength}$.
- `AddNoise(double Magnitude)`: Add uniform noise to mesh vertices.
- `RescaleCoordinates()`: Normalize mesh coordinates to unit range.
- `QuantizeCoordinates(int q)`: Quantize coordinates to integers ($q$ bits).
- `QuantizeCoordinatesLike(vtkSurface *Mesh)`: Quantize with same parameters as input mesh.
- `QuantizeCoordinates(double Factor, double Tx, double Ty, double Tz)`: Quantize with given parameters.
- `UnQuantizeCoordinates()`: Undo quantization.

#### Utility Methods

##### Orientation and Quality
- `EnsureOutwardsNormals()`: Correct mesh orientation based on signed volume.
- `SwitchOrientation()`: Reverse all face orientations.
- `GetBoundingBoxDiagonalLength()`: Calculate diagonal length of mesh bounding box.

##### Sharp Features
- `ComputeSharpVertices(double threshold)`: Compute sharp vertices based on angle threshold.
- `IsSharpVertex(vtkIdType v)`: Test if vertex is sharp (returns `1` or `0`).
- `DeleteSharpVertices()`: Clear sharp vertex computation.

##### Memory Management
- `CleanMemory()`: Return mesh with no empty memory slots.
- `DisplayMeshProperties()`: Display mesh statistics on screen.
- `GetMeshProperties(std::stringstream &stream)`: Store mesh properties in string stream.
- `SQueeze()`: Recover extra memory.

---

## Related Documentation

- [Root AGENTS.md](../AGENTS.md): Master repository guide & architectural context.
- [ACVD CLI Reference](../Readme.md#4-command-line-parameters-reference): Command line reference for ACVD executables.
- [Other Programs Documentation](other-programs.md): Auxiliary programs for volume and mesh processing.