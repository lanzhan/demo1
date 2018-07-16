package com.springboot.crud.bean;

import lombok.Data;

import java.io.Serializable;

@Data
public class user implements Serializable {
    private Integer id;

    private String name;

    private Integer age;

    private Integer phone;

    private String address;

    private Integer page;

    private Integer pageSize;
}
