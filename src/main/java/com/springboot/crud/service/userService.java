package com.springboot.crud.service;

import com.github.pagehelper.PageInfo;
import com.springboot.crud.bean.user;

public interface userService {
    void  insert(user user);
    PageInfo<user>findList(user user);

    void update(user user);
    void delete(user user);
}
