package com.springboot.crud.mapper;

import com.springboot.crud.bean.user;

import java.util.List;

public interface userMapper {
    void insert(user user);

    /**
     *
     * @param user
     * @return
     */
    List<user> select(user user);
    void update(user user);
    void delete(user user);
}
