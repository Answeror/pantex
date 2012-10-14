if(NOT PANTEX_INCLUDED)
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/acmake")
    include("${CMAKE_CURRENT_LIST_DIR}/UseLATEX.cmake")
    include(acmake_parse_arguments)
    set(PANTEX_DIR "${CMAKE_CURRENT_LIST_DIR}")
    set(PANTEX_INCLUDED TRUE)
endif()

macro(pantex)
    acmake_parse_arguments(
        "PANTEX"
        "BIB;IMAGE_DIRS;INPUTS;TEMPLATE;DEPENDS"
        ""
        ${ARGN}
        )
    
    set(PDFLATEX_COMPILER xelatex)
    latex_get_output_path(OUTPUT_DIR)
    
    # pandoc process
    if(NOT PANTEX_TEMPLATE)
        file(TO_NATIVE_PATH ${PANTEX_DIR}/template.tex PANTEX_TEMPLATE)
    endif()
    if(IS_ABSOLUTE "${PANTEX_TEMPLATE}")
    else()
        set(PANTEX_TEMPLATE "${CMAKE_CURRENT_SOURCE_DIR}/${PANTEX_TEMPLATE}")
    endif()
    set(PANTEX_SOURCE ${PANTEX_DEFAULT_ARGS})
    if(IS_ABSOLUTE "${PANTEX_SOURCE}")
    else()
        set(PANTEX_SOURCE "${CMAKE_CURRENT_SOURCE_DIR}/${PANTEX_SOURCE}")
    endif()
    file(TO_NATIVE_PATH ${PANTEX_SOURCE} PANTEX_SOURCE)
    set(PANTEX_DUMMY "${PANTEX_DIR}/main.tex")
    file(RELATIVE_PATH PANTEX_DUMMY "${CMAKE_CURRENT_SOURCE_DIR}" "${PANTEX_DUMMY}")
    file(TO_NATIVE_PATH "${PANTEX_DUMMY}" PANTEX_DUMMY)
    file(TO_NATIVE_PATH "${OUTPUT_DIR}/${PANTEX_DUMMY}" PANTEX_TEX)
    add_custom_target(
        preprocess
        DEPENDS ${PANTEX_TEMPLATE} ${PANTEX_SOURCE}
        COMMAND pandoc -S -N --template ${PANTEX_TEMPLATE} --toc
        ${PANTEX_SOURCE} -o ${PANTEX_TEX}
        )
    
    # copy bib file
    if(PANTEX_BIB)
        file(COPY ${PANTEX_BIB} DESTINATION "${CMAKE_BINARY_DIR}")
        file(GLOB PANTEX_BIBS RELATIVE "${CMAKE_BINARY_DIR}" "${CMAKE_BINARY_DIR}/*.bib")
    endif()

    # images
    if(NOT PANTEX_IMAGE_DIRS)
        set(PANTEX_IMAGE_DIRS "")
    endif()
    if(NOT PANTEX_INPUTS)
        set(PANTEX_INPUTS "")
    endif()

    if(NOT PANTEX_DEPENDS)
        set(PANTEX_DEPENDS "")
    endif()
    
    add_latex_document(
        "${PANTEX_DUMMY}"
        INPUTS ${PANTEX_INPUTS}
        DEPENDS preprocess ${PANTEX_DEPENDS}
        BIBFILES ${PANTEX_BIBS}
        IMAGE_DIRS ${PANTEX_IMAGE_DIRS}
        DEFAULT_PDF
        )
endmacro()
