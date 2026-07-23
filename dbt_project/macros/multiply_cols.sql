{% macro multiply_columns(column_1, column_2) %}
    ({{ column_1 }} * {{ column_2 }})
{% endmacro %}