meta:
  id: nsbmdlz
  file-extension: nsbmdlz
  endian: le
  encoding: UTF-8
  ks-opaque-types: true
seq:
  - id: nitro_file
    type: nitro_file
    
types:
  nitro_file:
    seq:
      - id: nitro_header_text
        contents: 'BMD0'
      - id: magic_stamp
        type: u4
      - id: file_len
        type: u4
      - id: header_size
        type: u2
      - id: block_count
        type: u2
      - id: block_offsets
        type: u4
        repeat: expr
        repeat-expr: block_count
      - id: block_instance
        type: block_instance(_index)
        repeat: expr
        repeat-expr: block_count

  block_instance:
    params:
      - id: index
        type: u4
    instances:
      some_block:
        type: some_block
        pos: _parent.block_offsets[index]

  some_block:
    seq:
      - id: block_start
        type: pos_cache
      - id: block_header
        type: block_header
      - id: block_body
        type:
          switch-on: block_header.block_header
          cases:
            '"MDL0"': mdl0_block
            '"TEX0"': tex0_block

  mdl0_block:
    seq:
      - id: section_header
        type: section_header
      - id: unknown_subsection_header
        type: unknown_subsection_header
      - id: unknown
        type: u4
        repeat: expr
        repeat-expr: section_header.item_count
      - id: data_subsection_header
        type: data_subsection_header
      - id: model_offsets
        type: u4
        repeat: expr
        repeat-expr: section_header.item_count
      - id: name_subsection
        type: name_subsection
        repeat: expr
        repeat-expr: section_header.item_count
      - id: model_instance
        type: model_instance(model_offsets[_index] + _parent.block_start.position)
        repeat: expr
        repeat-expr: section_header.item_count
    types:
      model_instance:
        params:
          - id: offset
            type: u4
        instances:
          model_section:
            type: model_section
            pos: offset
            
  model_section:
    seq:
      - id: block_start
        type: pos_cache
      - id: block_len
        type: u4
      - id: extra_data_offset
        type: u4
      - id: material_section_offset
        type: u4
      - id: polygon_section_offset
        type: u4
      - id: display_list_end_offset
        type: u4
      - id: unknown1
        type: u1
      - id: unknown2
        type: u1
      - id: unknown3
        type: u1
      - id: object_count
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
      - id: runtime_use_data1
        type: u4
      - id: runtime_use_data2
        type: u4
      - id: block_end
        type: pos_cache
        
    instances:
      object_def_section:
        type: object_def_section
        pos: block_end.position
      bone_def_section:
        type: bone_def_section
        pos: object_def_section.object_def_instance.last.object_def.block_end.position
      material_def_section:
        type: material_def_section
        pos: material_section_offset + block_start.position
      polygon_def_section:
        type: polygon_def_section
        pos: polygon_section_offset + block_start.position

  object_def_section:
    seq:
      - id: object_def_header
        type: object_def_header
      - id: object_def_instance
        type: object_def_instance(object_def_header.object_def_offsets[_index] + object_def_header.block_start.position)
        repeat: expr
        repeat-expr: object_def_header.section_header.item_count
        
    types:
      object_def_instance:
        params:
          - id: offset
            type: u4
        instances:
          object_def:
            type: object_def
            pos: offset
            
      object_def_header:
        seq:
          - id: block_start
            type: pos_cache
          - id: section_header
            type: section_header
          - id: pos_cache1
            type: pos_cache
          - id: unknown_subsection_header
            type: unknown_subsection_header
          - id: unknown9
            type: u4
            repeat: expr
            repeat-expr: section_header.item_count
          - id: data_subsection_header
            type: data_subsection_header
          - id: object_def_offsets
            type: u4
            repeat: expr
            repeat-expr: section_header.item_count
          - id: name_subsection
            type: name_subsection
            repeat: expr
            repeat-expr: section_header.item_count
            
      object_def:
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
            type: fxp_s4(8)
            if: has_no_translation == false
          - id: translation_y
            type: fxp_s4(8)
            if: has_no_translation == false
          - id: translation_z
            type: fxp_s4(8)
            if: has_no_translation == false
            
          - id: scale_x
            type: fxp_s4(8)
            if: has_no_scale == false
          - id: scale_y
            type: fxp_s4(8)
            if: has_no_scale == false
          - id: scale_z
            type: fxp_s4(8)
            if: has_no_scale == false
            
          - id: rotation_a
            type: s4
            if: (has_pivot == false) and (has_no_rotation == false)
          - id: rotation_b
            type: fxp_s4(8)
            if: (has_pivot == false) and (has_no_rotation == false)
          - id: rotation_c
            type: fxp_s4(8)
            if: (has_pivot == false) and (has_no_rotation == false)
          - id: rotation_d
            type: fxp_s4(8)
            if: (has_pivot == false) and (has_no_rotation == false)
            
          - id: pivot_a
            type: s2
            if: has_pivot == true
          - id: pivot_b
            type: s2
            if: has_pivot == true
            
          - id: block_end
            type: pos_cache

  bone_def_section:
    seq:
      - id: command
        type: command
        repeat: until
        repeat-until: _.command_id == 0x01
      - id: block_end
        type: pos_cache
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
          - id: no_value
            size: 0
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
            type: unknown_u1
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
  
  material_def_section:
    seq:
      - id: material_def_header
        type: material_def_header
      - id: material_def_instance
        type: material_def_instance(material_def_header.material_def_offsets[_index] + material_def_header.block_start.position)
        repeat: expr
        repeat-expr: material_def_header.section_header.item_count
        
    types:
      tex_pal_offset:
        seq:
          - id: tex_offset
            type: u2
          - id: pal_offset
            type: u2
          - id: block_end
            type: pos_cache
            
      material_def_header:
        seq:
          - id: block_start
            type: pos_cache
          - id: tex_pal_offset
            type: tex_pal_offset
          - id: section_header
            type: section_header
          - id: unknown_subsection_header
            type: unknown_subsection_header
          - id: unknown1
            type: u4
            repeat: expr
            repeat-expr: section_header.item_count
          - id: data_subsection_header
            type: data_subsection_header
          - id: material_def_offsets
            type: u4
            repeat: expr
            repeat-expr: section_header.item_count
          - id: name_subsection
            type: name_subsection
            repeat: expr
            repeat-expr: section_header.item_count
    
          - id: material_texture_section
            type: material_texture_section
          - id: material_palette_section
            type: material_palette_section
    
          - id: unknown2 # probably the texture index for materials
            type: u1
            repeat: expr
            repeat-expr: section_header.item_count
          - id: unknown3 # probably the palette index for materials
            type: u1
            repeat: expr
            repeat-expr: section_header.item_count
          - id: unknown4
            type: u2

      material_def_instance:
        params:
          - id: offset
            type: u4
        instances:
          material_def:
            type: material_def
            pos: offset
      
      material_def:
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
            type: unknown_u1
            size: block_len - 12
    
      material_texture_section:
        seq:
          - id: section_header
            type: section_header
          - id: unknown_subsection_header
            type: unknown_subsection_header
          - id: unknown1
            type: u4
            repeat: expr
            repeat-expr: section_header.item_count
          - id: data_subsection_header
            type: data_subsection_header
          - id: texture_def
            type: texture_def
            repeat: expr
            repeat-expr: section_header.item_count
          - id: name_subsection
            type: name_subsection
            repeat: expr
            repeat-expr: section_header.item_count
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
            repeat-expr: section_header.item_count
          - id: data_subsection_header
            type: data_subsection_header
          - id: palette_def
            type: palette_def
            repeat: expr
            repeat-expr: section_header.item_count
          - id: name_subsection
            type: name_subsection
            repeat: expr
            repeat-expr: section_header.item_count
        types:
          palette_def:
            seq:
              - id: matching_data_offset
                type: u2
              - id: material_use_count
                type: u2
  
  polygon_def_section:
    seq:
      - id: polygon_def_header
        type: polygon_def_header
      - id: polygon_def_start
        type: pos_cache
      - id: polygon_def_instance
        type: polygon_def_instance(polygon_def_header.polygon_def_offsets[_index] + polygon_def_header.block_start.position)
        repeat: expr
        repeat-expr: polygon_def_header.section_header.item_count
      - id: display_list_instance
        type: display_list_instance(polygon_def_instance[_index].polygon_def.display_list_offset + polygon_def_start.position, polygon_def_instance[_index].polygon_def.display_list_size / 8)
        repeat: expr
        repeat-expr: polygon_def_header.section_header.item_count
        
    types:
      polygon_def_header:
        seq:
          - id: block_start
            type: pos_cache
          - id: section_header
            type: section_header
          - id: unknown_subsection_header
            type: unknown_subsection_header
          - id: unknown9
            type: u4
            repeat: expr
            repeat-expr: section_header.item_count
          - id: data_subsection_header
            type: data_subsection_header
          - id: polygon_def_offsets
            type: u4
            repeat: expr
            repeat-expr: section_header.item_count
          - id: name_subsection
            type: name_subsection
            repeat: expr
            repeat-expr: section_header.item_count
            
      polygon_def_instance:
        params:
          - id: offset
            type: u4
        instances:
          polygon_def:
            type: polygon_def
            pos: offset
            
      polygon_def:
        seq:
          - id: unknown1
            type: u4
          - id: unknown2
            type: u4
          - id: display_list_offset
            type: u4
          - id: display_list_size
            type: u4
      
      display_list_instance:
        params:
          - id: offset
            type: u4
          - id: list_size
            type: u4
        instances:
          display_list:
            type: display_list(list_size)
            pos: offset
          #  size: list_size
            
      display_list:
        params:
          - id: list_size
            type: u4
        seq:
          - id: command
            type: packed_geometry_cmd
            repeat: until
            repeat-until: _.start_pos.position >= _parent.offset + list_size - 32
        types:
          packed_geometry_cmd:
            seq:
              - id: start_pos
                type: pos_cache
              - id: cmd_1
                type: u1
              - id: cmd_2
                type: u1
              - id: cmd_3
                type: u1
              - id: cmd_4
                type: u1
              - id: params_1
                type: param_switch(cmd_1)
              - id: params_2
                type: param_switch(cmd_2)
              - id: params_3
                type: param_switch(cmd_3)
              - id: params_4
                type: param_switch(cmd_4)
                    
          param_switch:
            params:
              - id: command
                type: u1
            seq:
              - id: param_list
                type:
                  switch-on: command
                  cases:
                    0x21: params_0x21
                    0x22: params_0x22
                    0x23: params_0x23
                    0x40: params_0x40
                    0x41: params_0x41
                    _: params_0x00
          
          params_0x40: # start of vertex list
            seq:
              - id: primitive_type
                type: b2
              - id: unused1
                type: b30
                
          params_0x41: # end of vertex list
            seq:
              - id: padding
                type: u4
                
          params_0x00: # end of display list
            seq:
              - id: empty
                size: 0
                
          params_0x21: # set normal vector
            seq:
              - id: padding
                type: b2
                # convert each b10 to s2 and divide by 512.0
              - id: normal_z
                type: b10
              - id: normal_y
                type: b10
              - id: normal_x
                type: b10
                
          params_0x22: # set texture coordinates
            seq:
              - id: u_coordinate
                type: fxp_s2(10)
              - id: v_coordinate
                type: fxp_s2(10)
          
          params_0x23: # set vertex xyz vector (W)
            seq:
              - id: vertex_x
                type: fxp_s2(12)
              - id: vertex_y
                type: fxp_s2(12)
              - id: vertex_z
                type: fxp_s2(12)
              - id: padding
                type: u2
  tex0_block:
    seq:
      - id: section_header
        type: section_header

  section_header:
    seq:
      - id: dummy_zero
        type: u1 #dummy zero
      - id: item_count
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

  block_header:
    seq:
      - id: block_header
        type: str
        size: 4
      - id: block_len
        type: u4

  unknown_u1:
    seq:
      - id: unknown_u1
        type: u1
        repeat: eos
  
  fxp_s4:
    params:
    - id: precision
      type: u4
    seq:
      - id: fxp
        type: s4
    instances:
      real_value:
        value: (fxp-1) / (( 1 << precision ) * 1.0)

  fxp_s2:
    params:
    - id: precision
      type: u4
    seq:
      - id: fxp
        type: s2
    instances:
      real_value:
        value: fxp / (( 1 << precision ) * 1.0)

  fxp_b10:
    params:
    - id: precision
      type: u4
    seq:
      - id: sign
        type: b1
      - id: fxp
        type: b9
    instances:
      bitmask:
        value: 0x03FF
      real_value:
        value: sign ? (0xFFFF - (fxp).as<s2>) : fxp

  pos_cache:
    instances:
      position:
        value: _root._io.pos
    seq:
      - size: 0
        if: position == 0
