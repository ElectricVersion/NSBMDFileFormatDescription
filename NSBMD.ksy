meta:
  id: nsbmd
  file-extension: nsbmd
  endian: le
  encoding: UTF-8
seq:
  - id: nitro_header
    type: nitro_header
  - id: unknown1
    type: unknown
    size: 4
    if: _io.pos < nitro_header.mdl0_offset
  - id: mdl0_header
    type: block_header
  - id: section_header
    type: section_header
  - id: unknown_subsection_header
    type: unknown_subsection_header
  - id: unknown
    type: u4
    repeat: expr
    repeat-expr: section_header.object_count
  - id: data_subsection_header
    type: data_subsection_header
  - id: model1_offset
    type: u4
    repeat: expr
    repeat-expr: section_header.object_count
  - id: name_subsection
    type: name_subsection
    repeat: expr
    repeat-expr: section_header.object_count
  - id: model_section_list
    type: model_section_list
types:
  nitro_header:
    seq:
      - id: nitro_header_text
        contents: 'BMD0'
      - id: unknown1
        type: unknown
        size: 12
      - id: mdl0_offset
        type: u4
  block_header:
    seq:
      - id: block_header
        type: str
        size: 4
      - id: block_len
        type: u4
  section_header:
    seq:
      - id: dummy_zero
        type: u1 #dummy zero
      - id: object_count
        type: u1
      - id: header_len
        type: u2
  unknown_subsection_header:
    seq:
      - id: subheader_len
        type: u2
      - id: subsection_len
        type: u2
      - id: unknown_constant1
        contents: [0x7f, 0x01, 0x00, 0x00]
  data_subsection_header:
    seq:
      - id: data_entry_size
        type: u2
      - id: subsection_len
        type: u2
  name_subsection: #no header for this one
    seq:
      - id: name
        type: str
        size: 16
  model_section_list:
    seq:
      - id: model_section_inst 
        type: model_section_inst(_index)
        repeat: expr
        repeat-expr: _parent.section_header.object_count
  model_section_inst:
    params:
      - id: i
        type: u4
    instances:
      model_section:
        type: model_section
        pos: _root.model1_offset[i] + _root.nitro_header.mdl0_offset
  model_section:
    seq:
      - id: model_section_header
        type: model_section_header
      - id: model_section_body
        type: model_section_body
        #size: model_section_header.block_len - 4
  model_section_header:
    seq:
      - id: block_len
        type: u4
  model_section_body:
    seq:
      - id: extra_data_offset
        type: u4
      - id: tex_pal_offset_offset
        type: u4
      - id: display_list_start_offset
        type: u4
      - id: display_list_end_offset
        type: u4
      - id: unknown1
        type: u1
      - id: unknown2
        type: u1
      - id: unknown3
        type: u1
      - id: mesh_object_count
        type: u1
      - id: material_count
        type: u1
      - id: polygon_count
        type: u1
      - id: unknown4
        type: u2
      - id: unknown5
        type: u2
      - id: unknown6
        type: u2
      - id: unknown7
        type: u2
      - id: unknown8
        type: u2
      - id: vertex_count
        type: u2
      - id: face_count
        type: u2
      - id: tri_count
        type: u2
      - id: quad_count
        type: u2
      - id: bounding_box_x
        type: s2
      - id: bounding_box_y
        type: s2
      - id: bounding_box_z
        type: s2
      - id: bounding_box_width
        type: s2
      - id: bounding_box_height
        type: s2
      - id: bounding_box_depth
        type: s2
      - id: unknown9
        type: u4
      - id: unknown10
        type: u4
      - id: section_header
        type: section_header
      - id: unknown11
        type: u4
        repeat: expr
        repeat-expr: _parent.mesh_object_count
      - id: object_def_header
        type: object_def_header
      - id: bone_def_body
        type: bone_def_body
      - id: tex_offset
        type: u2
      - id: pal_offset
        type: u2
      - id: section_header2
        type: section_header
      - id: material_def_header
        type: material_def_header
  material_def_header:
    seq:
      - id: unknown_subsection_header
        type: unknown_subsection_header
      - id: unknown1
        type: u1
        repeat: expr
        repeat-expr: _parent.material_count * 4
      - id: data_subsection_header
        type: data_subsection_header
      - id: material_def_offset
        type: u4
        repeat: expr
        repeat-expr: _parent.material_count
      - id: name_subsection
        type: name_subsection
        repeat: expr
        repeat-expr: _parent.material_count
      - id: material_texture_section
        type: material_texture_section
      - id: material_palette_section
        type: material_palette_section
        
      - id: unknown2 # probably the texture index for materials
        type: u1
        repeat: expr
        repeat-expr: _parent.material_count
      - id: unknown3 # probably the palette index for materials
        type: u1
        repeat: expr
        repeat-expr: _parent.material_count
      - id: unknown4
        type: u2
        
      - id: material_def_list
        type: material_def_list
  material_texture_section:
    seq:
      - id: section_header
        type: section_header
      - id: unknown_subsection_header
        type: unknown_subsection_header
      - id: unknown1
        type: u4
        repeat: expr
        repeat-expr: section_header.object_count
      - id: data_subsection_header
        type: data_subsection_header
      - id: texture_def
        type: texture_def
        repeat: expr
        repeat-expr: section_header.object_count
      - id: name_subsection
        type: name_subsection
        repeat: expr
        repeat-expr: section_header.object_count
    types:
      texture_def:
        seq:
          - id: matching_data_offset
            type: u2
          - id: material_use_count
            type: u2
  material_palette_section:
    seq:
      - id: section_header
        type: section_header
      - id: unknown_subsection_header
        type: unknown_subsection_header
      - id: unknown1
        type: u4
        repeat: expr
        repeat-expr: section_header.object_count
      - id: data_subsection_header
        type: data_subsection_header
      - id: palette_def
        type: palette_def
        repeat: expr
        repeat-expr: section_header.object_count
      - id: name_subsection
        type: name_subsection
        repeat: expr
        repeat-expr: section_header.object_count
    types:
      palette_def:
        seq:
          - id: matching_data_offset
            type: u2
          - id: material_use_count
            type: u2
  material_def_list:
    seq:
      - id: material_def_instance
        type: material_def_instance #(_parent.material_def_offset[_index])
        repeat: expr
        repeat-expr: _parent._parent.material_count
  material_def_instance:
    params:
      - id: offset
        type: u4
    seq:
      - id: material_def_instance
        type: material_def_body
  material_def_body:
    seq:
      - id: unknown1 # seems to always be 0x0000, comes at start of block
        type: u2
      - id: block_len
        type: u2
      - id: diffuse_r #possible red channel diffuse
        type: b5
      - id: diffuse_g #possible green channel diffuse
        type: b5
      - id: diffuse_b #possible blue channel diffuse
        type: b5
      - id: unknown5 #possible vertex color
        type: b1
      - id: ambient_r #possible red channel ambient
        type: b5
      - id: ambient_g #possible green channel ambient
        type: b5
      - id: ambient_b #possible blue channel ambient
        type: b5
      - id: unknown9 #possible unused
        type: b1
      - id: unknown10_r #possible red channel specular
        type: b5
      - id: unknown11_g #possible green channel specular
        type: b5
      - id: unknown12_b #possible blue channel specular
        type: b5
      - id: spec_shininess #possible specular shininess
        type: b1
      - id: unknown14_r #possible red channel emission
        type: b5
      - id: unknown15_g #possible green channel emission
        type: b5
      - id: unknown16_b #possible blue channel emission
        type: b5
      - id: unknown17 #possible unused
        type: b1
      - id: unknown_padding
        type: unknown
        size: block_len - 12
  object_def_header:
    seq:
      - id: pos_cache1
        type: pos_cache
      - id: unknown_subsection_header
        type: unknown_subsection_header
      - id: unknown1
        type: u4
        repeat: expr
        repeat-expr: _parent.mesh_object_count
      - id: data_subsection_header
        type: data_subsection_header
      - id: object_def_offset
        type: u4
        repeat: expr
        repeat-expr: _parent.mesh_object_count
      - id: name_subsection
        type: name_subsection
        repeat: expr
        repeat-expr: _parent.mesh_object_count
      - id: object_def_list
        type: object_def_list
  object_def_list:
    seq:
      - id: object_def_instance
        type: object_def_instance(_parent.object_def_offset[_index])
        repeat: expr
        repeat-expr: _parent._parent.mesh_object_count
  object_def_instance:
    params:
      - id: offset
        type: u4
    seq:
      - id: object_def_instance
        type: object_def_body
        #pos: _parent._parent.pos_cache1.position + offset - 4
  
  object_def_body:
    seq:
      - id: pivot_matrix_type
        type: b4
      - id: has_pivot
        type: b1
      - id: has_no_scale
        type: b1
      - id: has_no_rotation
        type: b1 
      - id: has_no_translation
        type: b1
      - id: unknown1
        type: u1
      - id: unknown2
        type: u1
      - id: unknown3
        type: u1
      - id: translation_x
        type: s4
        if: has_no_translation == false
      - id: translation_y
        type: s4
        if: has_no_translation == false
      - id: translation_z
        type: s4
        if: has_no_translation == false
        
      - id: scale_x
        type: s4
        if: has_no_scale == false
      - id: scale_y
        type: s4
        if: has_no_scale == false
      - id: scale_z
        type: s4
        if: has_no_scale == false
        
      - id: rotation_a
        type: s4
        if: (has_pivot == false) and (has_no_rotation == false)
      - id: rotation_b
        type: s4
        if: (has_pivot == false) and (has_no_rotation == false)
      - id: rotation_c
        type: s4
        if: (has_pivot == false) and (has_no_rotation == false)
      - id: rotation_d
        type: s4
        if: (has_pivot == false) and (has_no_rotation == false)
      - id: pivot_a
        type: s2
        if: has_pivot == true
      - id: pivot_b
        type: s2
        if: has_pivot == true
  bone_def_body:
    seq:
      - id: command
        type: command
        repeat: until
        repeat-until: _.command_id == 0x01
    types:
      command:
        seq:
          - id: command_id
            type: u1
          - id: parameters
            type:
              switch-on: command_id
              cases:
                0x00: params_0x00
                0x01: params_0x01
                0x02: params_0x02
                0x03: params_0x03
                0x04: params_0x04
                0x05: params_0x05
                0x06: params_0x06
                0x07: params_0x07
                0x08: params_0x08
                0x09: params_0x09
                0x0b: params_0x0b
                0x24: params_0x24
                0x26: params_0x26
                0x2b: params_0x2b
                0x46: params_0x46
                0x66: params_0x66
                _: params_0x00
      params_0x00: # NOP
        seq:
          - id: no_value
            size: 0
      params_0x01: # END OF BONE/SKELETON SECTION
        seq:
          - id: padding
            type: unknown
            size: 3
      params_0x02:
        seq:
          - id: node_id
            type: u1
          - id: visibility
            type: u1
      params_0x03: # SET POLYGON STACK ID?
        seq:
          - id: stack_id 
            type: u1
      params_0x04:
        seq:
          - id: material_id 
            type: u1
          - id: unknown1
            type: u1
          - id: polygon_id 
            type: u1
      params_0x05:
        seq:
          - id: unknown1
            type: u1
      params_0x06:
        seq:
          - id: object_id
            type: u1
          - id: parent_id
            type: u1
          - id: dummy_0
            type: u1
      params_0x07:
        seq:
          - id: unknown1
            type: u1
      params_0x08:
        seq:
          - id: unknown1
            type: u1
      params_0x09:
        seq:
          - id: unknown1
            type: unknown
            size: 8
      params_0x0b: # BEGIN POLYGON/MATERIAL PAIRING
        seq:
          - id: no_value
            size: 0
      params_0x24:
        seq:
          - id: material_id 
            type: u1
          - id: unknown1
            type: u1
          - id: polygon_id 
            type: u1
      params_0x26:
        seq:
          - id: object_id
            type: u1
          - id: parent_id
            type: u1
          - id: dummy_0
            type: u1
          - id: stack_id
            type: u1
      params_0x2b: # END POLYGON/MATERIAL PAIRING
        seq:
          - id: no_value
            size: 0
      params_0x46:
        seq:
          - id: object_id
            type: u1
          - id: parent_id
            type: u1
          - id: dummy_0
            type: u1
          - id: stack_id
            type: u1
      params_0x66:
        seq:
          - id: object_id
            type: u1
          - id: parent_id
            type: u1
          - id: dummy_0
            type: u1
          - id: stack_id
            type: u1
          - id: restore_id
            type: u1
  unknown:
    seq:
      - id: unknown
        type: u1
        repeat: eos
  pos_cache:
    instances:
      position:
        value: _io.pos
    seq:
      - size: 0
        if: position == 0