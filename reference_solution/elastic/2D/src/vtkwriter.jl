function vtk_grid_no_compress(topology::Matrix{Int}, Coord::Matrix, filename::AbstractString)

    nele = size(topology, 2)
    nen = size(topology,1)
    nnodes = size(Coord, 2)
    ndim = size(Coord, 1)

    cell = JuAFEM.get_cell_type(nen, ndim)

    points = Coord
    points = JuAFEM.pad_zeros(points, ndim, nnodes)

    cells = MeshCell[MeshCell(cell, topology[:,i]) for i = 1:nele]

    vtk = vtk_grid(filename, points, cells, compress=false, append=false)
    return vtk
end

function vtkwriter(pvd,i,u_mesh,u)

    nnodes = div(length(u),2)

    displacement = reshape(u,(2,nnodes))
    displacement = [displacement; zeros(nnodes)']

    # dof = reshape(1:2*nnodes,(2,nnodes))

    vtkfile = vtk_grid_no_compress(u_mesh.mesh,u_mesh.coord,"./vtkfiles/step_$i")
    vtk_point_data(vtkfile,displacement,"displacement")
    collection_add_timestep(pvd,vtkfile,float(i))
end